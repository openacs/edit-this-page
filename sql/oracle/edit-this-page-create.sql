-- etp-create.sql
-- @author Luke Pond (dlpond@pobox.com)
-- @creation-date 2001-05-31
--
-- Ported to Oracle by Jon Griffin and Don Baccus

create sequence etp_auto_page_number_seq;

create or replace package etp
as 
    function get_attribute_value ( 
      object_id    in acs_objects.object_id%TYPE,
      attribute_id in acs_attribute_values.attribute_id%TYPE
    ) return varchar;

    function create_page (
      package_id in apm_packages.package_id%TYPE,
      name       in varchar,
      title      in varchar,
      content_type in varchar default 'content_revision'
    ) return integer;

    function create_extlink (
      package_id in apm_packages.package_id%TYPE,
      url         in varchar,
      title       in varchar,
      description in varchar
    ) return integer;

    function create_symlink (
      package_id in apm_packages.package_id%TYPE,
      target_id  in integer
    ) return integer;

    function create_new_revision (
      package_id in apm_packages.package_id%TYPE,
      name in varchar,
      user_id    in users.user_id%TYPE
    ) return integer;

    function get_folder_id (
      package_id in apm_packages.package_id%TYPE
    ) return integer;

    function get_relative_url (
      item_id in cr_items.item_id%TYPE,
      name    in varchar
    ) return varchar;

    function get_title (
      item_id in cr_items.item_id%TYPE,
      revision_title in varchar
    ) return varchar;

    function get_description (
      item_id in cr_items.item_id%TYPE,
      revision_description in varchar
    ) return varchar;

end etp;
/
show errors


-- package bodies
create or replace package body etp
as 
    function get_attribute_value ( 
      object_id    in acs_objects.object_id%TYPE,
      attribute_id in acs_attribute_values.attribute_id%TYPE
    ) return varchar is
      v_value acs_attribute_values.attr_value%TYPE;
    begin
        select attr_value
        into v_value
        from acs_attribute_values
        where object_id = object_id
        and attribute_id = attribute_id;
        return v_value;
        exception when no_data_found then return null;
    end get_attribute_value;


    function create_page (
      package_id in apm_packages.package_id%TYPE,
      name       in varchar,
      title      in varchar,
      content_type in varchar default 'content_revision'
    ) return integer 
    is
        v_item_id cr_items.item_id%TYPE;
        v_revision_id cr_revisions.revision_id%TYPE;
        v_folder_id cr_folders.folder_id%TYPE;
    begin
       v_item_id := acs_object.new (
           null, 
           create_page.content_type, 
           sysdate(), 
           null, 
           null, 
           package_id
       );

       v_folder_id := etp.get_folder_id(package_id);

       insert into cr_items 
           (item_id, parent_id, name, content_type) 
       values 
           (v_item_id, v_folder_id, name, content_type);

-- due to a change in acs_object__delete we can reference the actual
-- object type we want
-- using this we can more easily search, but we will have to create a service
-- contract for each custom content type
-- we define a default etp_page_revision and service contract to go with it
-- make sure to subtype from etp_page_revision for any custom types
-- 2003-01-12 DaveB

      v_revision_id := acs_object.new(null, content_type);

      insert into cr_revisions (revision_id, item_id, title, 
                            publish_date, mime_type) 
      values (v_revision_id, v_item_id, title, sysdate, 'text/html');

      update cr_items 
          set live_revision = v_revision_id
          where item_id = v_item_id;

      return 1;
    end create_page;

    function create_extlink (
      package_id in apm_packages.package_id%TYPE,
      url         in varchar,
      title       in varchar,
      description in varchar
    ) return integer
    is
      v_item_id cr_items.item_id%TYPE;
      v_folder_id cr_folders.folder_id%TYPE;
    begin
      v_item_id := acs_object.new (
          null, 
          'content_extlink'
      );
      
      v_folder_id := etp.get_folder_id(package_id);

      insert into cr_items 
        (item_id, parent_id, name, content_type) 
      values 
        (v_item_id, v_folder_id, 
         'extlink ' || etp_auto_page_number_seq.nextval,
         'content_extlink');

      insert into cr_extlinks
        (extlink_id, url, label, description)
      values
        (v_item_id, url, title, description);

      return 1;
    end create_extlink;

    function create_symlink (
      package_id in apm_packages.package_id%TYPE,
      target_id  in integer
    ) return integer
    is
      v_item_id cr_items.item_id%TYPE;
      v_folder_id cr_folders.folder_id%TYPE;
    begin 
      v_item_id := acs_object.new(null, 'content_symlink');
      v_folder_id := etp.get_folder_id(package_id);

      insert into cr_items 
        ( item_id, parent_id, name, content_type) 
      values 
        ( v_item_id, v_folder_id, 
          'symlink ' || etp_auto_page_number_seq.nextval, 
          'content_symlink');

      insert into cr_symlinks
        (symlink_id, target_id)
      values
        (v_item_id, target_id);

      return 1;
    end create_symlink;

    function create_new_revision (
      package_id in apm_packages.package_id%TYPE,
      name in varchar,
      user_id    in users.user_id%TYPE
    ) return integer
    is
      v_revision_id cr_revisions.revision_id%TYPE;
      v_new_revision_id cr_revisions.revision_id%TYPE;
      v_content_type acs_objects.object_type%TYPE;
    begin

      select max(r.revision_id)
      into v_revision_id
      from cr_revisions r, cr_items i
      where i.name = name
      and i.parent_id = etp.get_folder_id(package_id)
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
        (v_new_revision_id, v_content_type, sysdate, user_id);

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
      package_id in apm_packages.package_id%TYPE
    ) return integer
    is
      v_folder_id cr_folders.folder_id%TYPE;
    begin
      select folder_id into v_folder_id
      from cr_folders
      where package_id = get_folder_id.package_id;
      return v_folder_id;
      exception when no_data_found then return content_item.c_root_folder_id;
    end get_folder_id;

    function get_relative_url (
      item_id in cr_items.item_id%TYPE,
      name    in varchar
    ) return varchar
    is
      v_url cr_extlinks.url%TYPE;
      v_object_type acs_objects.object_type%TYPE;
      v_package_id apm_packages.package_id%TYPE;
      v_name cr_items.name%TYPE;
      v_item_id cr_items.item_id%TYPE;

      cursor v_link_rec is
        select f.package_id, i.name
        from cr_items i, cr_folders f
        where i.item_id = v_item_id
        and i.parent_id = f.folder_id;

    begin

      select object_type into v_object_type
      from acs_objects
      where object_id = get_relative_url.item_id;

      if v_object_type = 'content_item' then
        return name;
      end if;

      -- is this portable? wouldn't seperator be better
      if v_object_type = 'content_folder' then
        return name || '/';
      end if;

      if v_object_type = 'content_extlink' then
        select url into v_url
        from cr_extlinks
        where extlink_id = get_relative_url.item_id;
        return v_url;
      end if;

      if v_object_type = 'content_symlink' then
        select target_id into v_item_id
        from cr_symlinks
        where symlink_id = get_relative_url.item_id;

        open v_link_rec;
        fetch v_link_rec into v_package_id, v_name;
        close v_link_rec;

        select site_node.url(s.node_id) into v_url
        from site_nodes s
        where s.object_id = v_package_id;

        return v_url || v_name;

      end if;

      return null;

    end get_relative_url;


    function get_title(
      item_id in cr_items.item_id%TYPE,
      revision_title in varchar
    ) return varchar
    is
      v_title cr_revisions.title%TYPE;
      v_object_type acs_objects.object_type%TYPE;
      v_item_id cr_items.item_id%TYPE;
    begin
      if revision_title is not null then
        return revision_title;
      end if;

      select object_type into v_object_type
      from acs_objects
      where object_id = get_title.item_id;

      if v_object_type = 'content_folder' then
        select r.title 
        into v_title
        from cr_items i, cr_revisions r
        where i.parent_id = get_title.item_id
        and i.name = 'index'
        and i.live_revision = r.revision_id;
        return v_title;    
      end if;

      if v_object_type = 'content_extlink' then
        select label into v_title
        from cr_extlinks
        where extlink_id = get_title.item_id;
        return v_title;
      end if;

      if v_object_type = 'content_symlink' then
        select target_id into v_item_id
        from cr_symlinks
        where symlink_id = get_title.item_id;
        return etp.get_title(v_item_id, null);
      end if;

      if v_object_type = 'content_item' then
        select r.title into v_title
        from cr_items i, cr_revisions r
        where i.item_id = get_title.item_id
        and i.live_revision = r.revision_id;
        return v_title;
      end if;  
   
      return null;

    end get_title;

    function get_description(
      item_id in cr_items.item_id%TYPE,
      revision_description in varchar
    ) return varchar
    is 
      v_description cr_revisions.description%TYPE;
      v_object_type acs_objects.object_type%TYPE;
      v_item_id cr_items.item_id%TYPE;
    begin
      if revision_description is not null then
        return revision_description;
      end if;

      select object_type into v_object_type
      from acs_objects
      where object_id = get_description.item_id;

      if v_object_type = 'content_folder' then
        select r.description 
        into v_description
        from cr_items i, cr_revisions r
        where i.parent_id = get_description.item_id
        and i.name = 'index'
        and i.live_revision = r.revision_id
        and i.item_id = r.item_id;
        return v_description;    
      end if;

      if v_object_type = 'content_extlink' then
        select description into v_description
        from cr_extlinks
        where extlink_id = get_description.item_id;
        return v_description;
      end if;

      if v_object_type = 'content_symlink' then
        select target_id into v_item_id
        from cr_symlinks
        where symlink_id = get_description.item_id;
        return etp.get_description(item_id, null);
      end if;

      if v_object_type = 'content_item' then
        select r.description into v_description
        from cr_items i, cr_revisions r
        where i.item_id = get_description.item_id
        and i.live_revision = r.revision_id;
        return v_description;
      end if;  

      return null;

    end get_description;
end etp;
/
show errors

-- add the ETP parameters to the acs-subsite package so that
-- we can serve the site's home page and top level pages.

-- DRB: this was trying to set the parameter values to their default value but they
-- already (quite logically) are set by apm.register_parameter ...

declare
  v_parameter_id apm_parameters.parameter_id%TYPE;

begin
  v_parameter_id := apm.register_parameter(
       package_key         => 'acs-subsite',
       parameter_name      => 'application',
       description         => 'Name of the ETP application to use (default, faq, wiki, or create your own with the etp::define_applicaton procedure)',
       datatype            => 'string',
       default_value       => 'default',
       section_name        => 'EditThisPage',
       min_n_values        => 1,
       max_n_values        => 1
  );

  v_parameter_id := apm.register_parameter(
       package_key         => 'acs-subsite',
       parameter_name      => 'subtopic_application',
       description         => 'Name of the ETP application to use when creating a subtopic',
       datatype            => 'string',
       default_value       => 'default',
       section_name        => 'EditThisPage',
       min_n_values        => 1,
       max_n_values        => 1
  );

end;
/
show errors;

-- create a folder with magic folder_id of -400 where we
-- will put all deleted content items so they'll be recoverable.

declare
  v_folder_id cr_folders.folder_id%TYPE;
begin
  select folder_id into v_folder_id from cr_folders where folder_id = -400;
  exception when no_data_found then 
    v_folder_id := content_folder.new (
           name           => 'trash',
           label          => 'Trash', 
           description    => 'Deleted content items get put here',
           folder_id      => -400
    );
end;
/
show errors;
