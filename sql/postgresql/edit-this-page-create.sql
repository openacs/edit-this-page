-- etp-create.sql
-- @author Luke Pond (dlpond@pobox.com)
-- @creation-date 2001-05-31
--

create sequence t_etp_auto_page_number_seq;
create view etp_auto_page_number_seq as
select nextval('t_etp_auto_page_number_seq') as nextval;

create function etp__get_attribute_value (integer, integer) 
returns varchar as '
declare
  p_object_id alias for $1;
  p_attribute_id alias for $2;
  v_value varchar;
begin
  select attr_value
    into v_value
    from acs_attribute_values
   where object_id = p_object_id
     and attribute_id = p_attribute_id;

  if not found then
    v_value := '''';
  end if;

  return v_value;
end;
' language 'plpgsql';



create function etp__create_page(integer, varchar, varchar, varchar)
returns integer as '
declare
  p_package_id alias for $1;
  p_name alias for $2;
  p_title alias for $3;
  p_content_type alias for $4;  -- default null -> use content_revision
  v_item_id integer;
  v_revision_id integer;
  v_folder_id integer;
begin
  v_item_id := acs_object__new(null, ''content_item'', now(), null, null, p_package_id);

  v_folder_id := etp__get_folder_id(p_package_id);

-- due to a change in acs_object__delete we can reference the actual
-- object type we want
-- using this we can more easily search, but we will have to create a service
-- contract for each custom content type
-- we define a default etp_page_revision and service contract to go with it
-- make sure to subtype from etp_page_revision for any custom types
-- 2003-01-12 DaveB

  insert into cr_items (
    item_id, parent_id, name, content_type
  ) values (
    v_item_id, v_folder_id, p_name, p_content_type
  );

  v_revision_id := acs_object__new(null, p_content_type, now(), null, null, v_item_id);

  insert into cr_revisions (revision_id, item_id, title, 
                            publish_date, mime_type) 
  values (v_revision_id, v_item_id, p_title, now(), ''text/html'');

  update cr_items set live_revision = v_revision_id
                  where item_id = v_item_id;

  return 1;
end;
' language 'plpgsql';

create function etp__create_extlink(integer, varchar, varchar, varchar)
returns integer as '
declare
  p_package_id alias for $1;
  p_url alias for $2;
  p_title alias for $3;
  p_description alias for $4; 
  v_item_id integer;
  v_folder_id integer;
begin
  v_item_id := acs_object__new(null, ''content_extlink'');
  v_folder_id := etp__get_folder_id(p_package_id);

  insert into cr_items (
    item_id, parent_id, name, content_type
  ) values (
    v_item_id, v_folder_id, ''extlink '' || etp_auto_page_number_seq.nextval, ''content_extlink''
  );

  insert into cr_extlinks
    (extlink_id, url, label, description)
  values
    (v_item_id, p_url, p_title, p_description);

  return 1;
end;
' language 'plpgsql';

create function etp__create_symlink(integer, integer)
returns integer as '
declare
  p_package_id alias for $1;
  p_target_id alias for $2;
  v_item_id integer;
  v_folder_id integer;
begin
  v_item_id := acs_object__new(null, ''content_symlink'');
  v_folder_id := etp__get_folder_id(p_package_id);

  insert into cr_items (
    item_id, parent_id, name, content_type
  ) values (
    v_item_id, v_folder_id, ''symlink '' || etp_auto_page_number_seq.nextval, ''content_symlink''
  );

  insert into cr_symlinks
    (symlink_id, target_id)
  values
    (v_item_id, p_target_id);

  return 1;
end;
' language 'plpgsql';

create or replace function etp__create_new_revision(integer, varchar, integer)
returns integer as '
declare
  p_package_id alias for $1;
  p_name alias for $2;
  p_user_id alias for $3;
  v_revision_id integer;
  v_item_id integer;
  v_new_revision_id integer;
  v_content_type varchar;
begin

  select max(r.revision_id)
    into v_revision_id
    from cr_revisions r, cr_items i
   where i.name = p_name
     and i.parent_id = etp__get_folder_id(p_package_id)
     and r.item_id = i.item_id;

  select item_id
    into v_item_id
    from cr_revisions
   where revision_id = v_revision_id;

  select object_type
    into v_content_type
    from acs_objects
   where object_id = v_revision_id;

  -- cannot use acs_object__new because it creates attributes with their
  -- default values, which is not what we want.

  select acs_object_id_seq.nextval
    into v_new_revision_id from dual;

  insert into acs_objects (object_id, object_type, creation_date, creation_user, context_id)
  values (v_new_revision_id, v_content_type, now(), p_user_id, v_item_id);

  insert into cr_revisions (revision_id, item_id, title, description, content, mime_type) 
  select v_new_revision_id, item_id, title, description, content, mime_type
    from cr_revisions r
   where r.revision_id = v_revision_id;

  -- copy extended attributes to the new revision, if there are any
  insert into acs_attribute_values (object_id, attribute_id, attr_value)
  select v_new_revision_id as object_id, attribute_id, attr_value
    from acs_attribute_values
   where object_id = v_revision_id;

  return 1;
end;
' language 'plpgsql';


create function etp__get_folder_id (integer)
returns integer as '
declare
    p_package_id alias for $1;
    v_folder_id integer;
    v_parent_id integer;
begin
    select folder_id into v_folder_id
      from cr_folders
     where package_id = p_package_id;
    if not found then 
        select parent_id into v_parent_id
          from site_nodes
         where object_id = p_package_id;
        if found and v_parent_id is null then
            v_folder_id := content_item_globals.c_root_folder_id;
        else
            -- This is probably an ETP app instance that
            -- was created through the Site Map; by returning
	    -- 0 we ensure the get_page_attributes query will
	    -- fail and index.vuh will redirect to etp-setup-2.
            v_folder_id := 0;
        end if;
    end if;

    return v_folder_id;
end;
' language 'plpgsql';


create function etp__get_relative_url(integer, varchar)
returns varchar as '
declare
  p_item_id alias for $1;
  p_name alias for $2;
  v_item_id integer;
  v_url varchar(400);
  v_object_type varchar;
  v_link_rec record;
begin

  select object_type into v_object_type
    from acs_objects
   where object_id = p_item_id;

  if v_object_type = ''content_item'' then
    return p_name;
  end if;

  if v_object_type = ''content_folder'' then
    select s.name || ''/'' into v_url
    from cr_folders f, site_nodes s
    where f.folder_id = p_item_id
    and s.object_id = f.package_id;
    return v_url;
  end if;

  if v_object_type = ''content_extlink'' then
    select url into v_url
      from cr_extlinks
     where extlink_id = p_item_id;
    return v_url;
  end if;

  if v_object_type = ''content_symlink'' then
    select target_id into v_item_id
      from cr_symlinks
     where symlink_id = p_item_id;

    select f.package_id, i.name
      into v_link_rec
      from cr_items i, cr_folders f
     where i.item_id = v_item_id
       and i.parent_id = f.folder_id;

    select site_node__url(s.node_id) into v_url
      from site_nodes s
     where s.object_id = v_link_rec.package_id;

    return v_url || v_link_rec.name;

  end if;

  return null;

end;
' language 'plpgsql';

create function etp__get_title(integer, varchar)
returns varchar as '
declare
  p_item_id alias for $1;
  p_revision_title alias for $2;
  v_item_id integer;
  v_title varchar(400);
  v_object_type varchar;
begin
  if p_revision_title is not null then
    return p_revision_title;
  end if;

  select object_type from acs_objects into v_object_type
   where object_id = p_item_id;

  if v_object_type = ''content_folder'' then
    select r.title 
      into v_title
      from cr_items i, cr_revisions r
     where i.parent_id = p_item_id
       and i.name = ''index''
       and i.live_revision = r.revision_id;
    return v_title;    
  end if;

  if v_object_type = ''content_extlink'' then
    select label into v_title
      from cr_extlinks
     where extlink_id = p_item_id;
    return v_title;
  end if;

  if v_object_type = ''content_symlink'' then
    select target_id into v_item_id
      from cr_symlinks
     where symlink_id = p_item_id;
    return etp__get_title(v_item_id, null);
  end if;

  if v_object_type = ''content_item'' then
    select r.title into v_title
      from cr_items i, cr_revisions r
     where i.item_id = v_item_id
       and i.live_revision = r.revision_id;
    return v_title;
  end if;  
   
  return null;

end;
' language 'plpgsql';

create function etp__get_description(integer, varchar)
returns varchar as '
declare
  p_item_id alias for $1;
  p_revision_description alias for $2;
  v_item_id integer;
  v_description varchar(400);
  v_object_type varchar;
begin
  if p_revision_description is not null then
    return p_revision_description;
  end if;

  select object_type from acs_objects into v_object_type
   where object_id = p_item_id;

  if v_object_type = ''content_folder'' then
    select r.description 
      into v_description
      from cr_items i, cr_revisions r
     where i.parent_id = p_item_id
       and i.name = ''index''
       and i.live_revision = r.revision_id
       and i.item_id = r.item_id;
    return v_description;    
  end if;

  if v_object_type = ''content_extlink'' then
    select description into v_description
      from cr_extlinks
     where extlink_id = p_item_id;
    return v_description;
  end if;

  if v_object_type = ''content_symlink'' then
    select target_id into v_item_id
      from cr_symlinks
     where symlink_id = p_item_id;
    return etp__get_description(v_item_id, null);
  end if;

  if v_object_type = ''content_item'' then
    select r.description into v_description
      from cr_items i, cr_revisions r
     where i.item_id = v_item_id
       and i.live_revision = r.revision_id;
    return v_description;
  end if;  

  return null;

end;' language 'plpgsql';





-- add the ETP parameters to the acs-subsite package so that
-- we can serve the site's home page and top level pages.

-- DRB: This page was setting the parameter default values explicitly.   apm__register_parameter
-- is supposed to do this - there was a mistake in the Oracle->PostgreSQL port of this function.
-- I fixed the bug and removed the code that was here ...

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
       1,
       1
      );
  perform apm__register_parameter(
       NULL,
       ''acs-subsite'',
       ''subtopic_application'',
       ''Name of the ETP application to use when creating a subtopic'',
       ''string'',
       ''default'',
       ''EditThisPage'',
       1,
       1
      );

  return 0;
end;
' language 'plpgsql';

select inline_0 ();
drop function inline_0 ();


-- create a folder with magic folder_id of -400 where we
-- will put all deleted content items so they'll be recoverable.

create function inline_1 () 
returns integer as '
declare
  v_folder_id integer;
begin
select folder_id into v_folder_id from cr_folders where folder_id = -400;
if not found then 
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
end if;
return 0;
end;
' language 'plpgsql';

select inline_1 ();
drop function inline_1 ();

-- create a default content_type etp_page_revision
-- DaveB
-- this references a non-existant table
-- which I might have to change...
select content_type__create_type (
        'etp_page_revision',        -- content_type
	'content_revision',         -- supertype
	'ETP managed page',       -- pretty_name
	'ETP managed pages',      -- pretty_plural
	'etp_page_revisions',            -- table_name
	'etp_page_revision_id',              -- id_column
	'content_revision__revision_name'  -- name_method
);
