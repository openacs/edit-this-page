-- etp-create.sql
-- @author Luke Pond (dlpond@pobox.com)
-- @creation-date 2001-05-31
--
alter table cr_folders
add package_id integer references apm_packages;

create sequence t_etp_auto_page_number_seq;
--create view etp_auto_page_number_seq as
--select nextval('t_etp_auto_page_number_seq') as nextval;
--- package decs
create or replace package body etp
as 
    function get_attribute_value ( 
    returns varchar as '
        p_object_id    in integer
        p_attribute_id in integer
        v_value varchar
    ) return varchar;

    function create_page (
        p_package_id in integer
        p_name       in varchar
        p_title      in varchar
        p_content_type in varchar default null -- -> use content_revision
    ) return integer;

    function create_extlink (
      p_package_id  in integer
      p_url         in varchar
      p_title       in varchar
      p_description in varchar 
    ) return integer;

    function create_symlink (
      p_package_id in integer
      p_target_id  in integer
    ) return integer;

    function create_new_revision (
      p_package_id in integer
      p_name alias in varchar
      p_user_id    in integer
    ) return integer;

    function get_folder_id (
      p_package_id in integer
    ) return integer;

    function get_relative_url (
      p_item_id in integer
      p_name    in varchar
    ) return varchar;

    function get_title (
      p_item_id        in integer
      p_revision_title in varchar
    ) return varchar;

    function get_description (
      p_item_id              in integer
      p_revision_description in varchar
    ) return varchar;

end etp;
/
show errors

-- package bodies
create or replace package body etp
as 
    function get_attribute_value ( 
    returns varchar as '
        p_object_id    in integer
        p_attribute_id in integer
        v_value varchar
    ) return varchar
    is
    begin
        select attr_value
        into v_value
        from acs_attribute_values
        where object_id = p_object_id
        and attribute_id = p_attribute_id;

        if not found then
            v_value := '';
        end if;

        return v_value;
    end get_attribute_value;


    function create_page (
        p_package_id in integer
        p_name       in varchar
        p_title      in varchar
        p_content_type in varchar default null -- -> use content_revision
    ) return integer 
    is
        v_item_id integer;
        v_revision_id integer;
        v_content_type varchar;
        v_folder_id integer;
    begin
       v_item_id := acs_object.new (
           null, 
           'content_item', 
           sysdate(), 
           null, 
           null, 
           p_package_id
       );

       v_folder_id := etp.get_folder_id(p_package_id);

       insert into cr_items 
           (item_id, parent_id, name, content_type) 
       values 
           (v_item_id, v_folder_id, p_name, v_content_type);

      -- would like to use p_content_type here, but since there''s 
      -- no table that corresponds to it, we get an error from
      -- the dynamic sql in acs_object__delete.  so just use content_revision.

      v_content_type := 'content_revision';
      v_revision_id := acs_object.new(null, v_content_type);

      insert into cr_revisions (revision_id, item_id, title, 
                            publish_date, mime_type) 
      values (v_revision_id, v_item_id, p_title, now(), 'text/html');

      update cr_items 
          set live_revision = v_revision_id
          where item_id = v_item_id;

      return 1;
    end create_page;

    function create_extlink (
      p_package_id  in integer
      p_url         in varchar
      p_title       in varchar
      p_description in varchar 
    ) return integer
    is
      v_item_id integer;
      v_folder_id integer;
    begin
      v_item_id := acs_object.new (
          null, 
          'content_extlink'
      );
      
      v_folder_id := etp_get_folder_id(p_package_id);

      insert into cr_items 
        (item_id, parent_id, name, content_type) 
      values 
        (v_item_id, v_folder_id, 
         'extlink ' || etp_auto_page_number_seq.nextval,
         'content_extlink');

      insert into cr_extlinks
        (extlink_id, url, label, description)
      values
        (v_item_id, p_url, p_title, p_description);

      return 1;
    end create_extlink;

    function create_symlink (
      p_package_id in integer
      p_target_id  in integer
    ) return integer
    is
      v_item_id integer;
      v_folder_id integer;
    begin 
      v_item_id := acs_object.new(null, 'content_symlink');
      v_folder_id := etp.get_folder_id(p_package_id);

      insert into cr_items 
        ( item_id, parent_id, name, content_type) 
      values 
        ( v_item_id, v_folder_id, 
          'symlink ' || etp_auto_page_number_seq.nextval, 
          'content_symlink');

      insert into cr_symlinks
        (symlink_id, target_id)
      values
        (v_item_id, p_target_id);

      return 1;
    end create_symlink;

    function create_new_revision (
      p_package_id in integer
      p_name alias in varchar
      p_user_id    in integer
    ) return integer
    is
      v_revision_id integer;
      v_new_revision_id integer;
      v_content_type varchar;
    begin

      select max(r.revision_id)
      into v_revision_id
      from cr_revisions r, cr_items i
      where i.name = p_name
      and i.parent_id = etp_get_folder_id(p_package_id)
      and r.item_id = i.item_id;

      select object_type
      into v_content_type
      from acs_objects
      where object_id = v_revision_id;

     -- cannot use acs_object__new because it creates attributes with their
    -- default values, which is not what we want.

      select acs_object_id_seq.nextval
      into v_new_revision_id from dual;

      insert into acs_objects 
        ( object_id, object_type, creation_date, creation_user)
      values 
        (v_new_revision_id, v_content_type, now(), p_user_id);

      insert into cr_revisions 
        (revision_id, item_id, title, description, content, mime_type) 
          select v_new_revision_id, 
                 item_id, title, 
                 description, content, mime_type
          from cr_revisions r
          where r.revision_id = v_revision_id;

      -- copy extended attributes to the new revision, if there are any
         insert into acs_attribute_values 
           (object_id, attribute_id, attr_value)
              select v_new_revision_id as object_id, 
                     attribute_id, attr_value
               from acs_attribute_values
               where object_id = v_revision_id;

      return 1;
    end create_new_revision;

    function get_folder_id (
      p_package_id in integer
    ) return integer
    is
      v_folder_id integer;
    begin
      select folder_id into v_folder_id
      from cr_folders
      where package_id = p_package_id;
    
      if not found then 
        v_folder_id := content_item_globals.c_root_folder_id;
      end if;

      return v_folder_id;
    end get_folder_id;

    function get_relative_url (
      p_item_id in integer
      p_name    in varchar
    ) return varchar
    is
      v_url varchar(400);
      v_object_type varchar;
      v_link_rec record;
    begin

      select object_type into v_object_type
      from acs_objects
      where object_id = p_item_id;

      if v_object_type = 'content_item' then
        return p_name;
      end if;

      -- is this portable? wouldn't seperator be better
      if v_object_type = 'content_folder' then
        return p_name || '/';
      end if;

      if v_object_type = 'content_extlink' then
        select url into v_url
        from cr_extlinks
        where extlink_id = p_item_id;
        return v_url;
      end if;

      if v_object_type = 'content_symlink' then
        select target_id into p_item_id
        from cr_symlinks
        where symlink_id = p_item_id;

        select f.package_id, i.name
        into v_link_rec
        from cr_items i, cr_folders f
        where i.item_id = p_item_id
        and i.parent_id = f.folder_id;

        select site_node.url(s.node_id) into v_url
        from site_nodes s
        where s.object_id = v_link_rec.package_id;

        return v_url || v_link_rec.name;

      end if;

      return null;

    end get_relative_url;


    function get_title(
      p_item_id        in integer
      p_revision_title in varchar
    ) return varchar
    is
      v_title varchar(400);
      v_object_type varchar;
    begin
      if p_revision_title is not null then
        return p_revision_title;
      end if;

      select object_type 
      from acs_objects into v_object_type
      where object_id = p_item_id;

      if v_object_type = 'content_folder' then
        select r.title 
        into v_title
        from cr_items i, cr_revisions r
        where i.parent_id = p_item_id
        and i.name = 'index'
        and i.live_revision = r.revision_id;
        return v_title;    
      end if;

      if v_object_type = 'content_extlink' then
        select label into v_title
        from cr_extlinks
        where extlink_id = p_item_id;
        return v_title;
      end if;

      if v_object_type = 'content_symlink' then
        select target_id into p_item_id
        from cr_symlinks
        where symlink_id = p_item_id;
        return etp_get_title(p_item_id, null);
      end if;

      if v_object_type = 'content_item' then
        select r.title into v_title
        from cr_items i, cr_revisions r
        where i.item_id = p_item_id
        and i.live_revision = r.revision_id;
        return v_title;
      end if;  
   
      return null;

    end get_title;

    function get_description(
      p_item_id              in integer
      p_revision_description in varchar
    ) return varchar
    is 
      v_description varchar(400);
      v_object_type varchar;
    begin
      if p_revision_description is not null then
        return p_revision_description;
      end if;

      select object_type 
      from acs_objects into v_object_type
      where object_id = p_item_id;

      if v_object_type = 'content_folder' then
        select r.description 
        into v_description
        from cr_items i, cr_revisions r
        where i.parent_id = p_item_id
        and i.name = 'index'
        and i.live_revision = r.revision_id
        and i.item_id = r.item_id;
        return v_description;    
      end if;

      if v_object_type = 'content_extlink' then
        select description into v_description
        from cr_extlinks
        where extlink_id = p_item_id;
        return v_description;
      end if;

      if v_object_type = 'content_symlink' then
        select target_id into p_item_id
        from cr_symlinks
        where symlink_id = p_item_id;
        return etp_get_description(p_item_id, null);
      end if;

      if v_object_type = 'content_item' then
        select r.description into v_description
        from cr_items i, cr_revisions r
        where i.item_id = p_item_id
        and i.live_revision = r.revision_id;
        return v_description;
      end if;  

      return null;

    end get_description;
end etp;
/
show errors

-- this is a workaround for a bug in postgresql 7.1
-- that causes the cr_revision__delete function to 
-- trigger a "data change violation" as a result of
-- a row being inserted and then deleted from the
-- cr_item_publish_audit table in the same transaction.
-- see http://openacs.org/bboard/q-and-a-fetch-msg.tcl?msg_id=0001x3&topic_id=12&topic=OpenACS%204%2e0%20Design

-- this effectively drops all constraints (foreign key and otherwise)
-- from the audit table.

create table cr_audit_temp as select * from cr_item_publish_audit;
drop table cr_item_publish_audit;
create table cr_item_publish_audit as select * from cr_audit_temp;
drop table cr_audit_temp;



-- add the ETP parameters to the acs-subsite package so that
-- we can serve the site's home page and top level pages.

create function inline_0 () 
returns integer as '
declare
  ss_package_id integer;
  cur_val record;
begin
  perform apm__register_parameter(
       NULL,
       ''acs-subsite'',
       ''application'',
       ''Name of the ETP application to use (default, faq, wiki, or create your own with the etp::define_applicaton procedure)'',
       ''string'',
       ''default'',
       ''EditThisPage'',
       ''1'',
       ''1''
      );
  perform apm__register_parameter(
       NULL,
       ''acs-subsite'',
       ''subtopic_application'',
       ''Name of the ETP application to use when creating a subtopic'',
       ''string'',
       ''default'',
       ''EditThisPage'',
       ''1'',
       ''1''
      );

  select package_id into ss_package_id
    from apm_packages
   where package_key = ''acs-subsite'';

  for cur_val in select parameter_id, default_value
     from apm_parameters
     where package_key = ''acs-subsite''
     and section_name = ''EditThisPage''
  loop
      perform apm_parameter_value__new(
        null,
        ss_package_id,
        cur_val.parameter_id,
        cur_val.default_value
      ); 
  end loop;   

  return 0;
end;
' language 'plpgsql';

select inline_0 ();
drop function inline_0 ();


-- create a folder with magic folder_id of -400 where we
-- will put all deleted content items so they'll be recoverable.

create function inline_1 () 
returns integer as '
begin
perform content_folder__new (
    ''trash'',
    ''Trash'', 
    ''Deleted content items get put here'',
    0,
    null,
    -400,
    now(),
    null,
    null
  );
return 0;
end;
' language 'plpgsql';

select inline_1 ();
drop function inline_1 ();
