-- etp-create.sql
-- @author Luke Pond (dlpond@pobox.com)
-- @creation-date 2001-05-31
--

create sequence t_etp_auto_page_number_seq;
create view etp_auto_page_number_seq as
select nextval('t_etp_auto_page_number_seq') as nextval;



select define_function_args('etp__get_attribute_value','object_id,attribute_id');
--
-- procedure etp__get_attribute_value/2
--
CREATE OR REPLACE FUNCTION etp__get_attribute_value(
   p_object_id integer,
   p_attribute_id integer
) RETURNS varchar AS $$
DECLARE
  v_value varchar;
BEGIN
  select attr_value
    into v_value
    from acs_attribute_values
   where object_id = p_object_id
     and attribute_id = p_attribute_id;

  if not found then
    v_value := '';
  end if;

  return v_value;
END;

$$ LANGUAGE plpgsql;





--
-- procedure etp__create_page/4
--
CREATE OR REPLACE FUNCTION etp__create_page(
   p_package_id integer,
   p_name varchar,
   p_title varchar,
   p_content_type varchar -- default null -> use content_revision

) RETURNS integer AS $$
DECLARE
  v_item_id integer;
  v_revision_id integer;
  v_folder_id integer;
BEGIN
  v_item_id := acs_object__new(null, 'content_item', now(), null, null, p_package_id);

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
  values (v_revision_id, v_item_id, p_title, now(), 'text/enhanced');

  update cr_items set live_revision = v_revision_id
                  where item_id = v_item_id;

  return 1;
END;
$$ LANGUAGE plpgsql;




select define_function_args('etp__create_page','item_id,package_id,name,title,content_type;null');

--
-- procedure etp__create_page/5
--
CREATE OR REPLACE FUNCTION etp__create_page(
   p_item_id integer,
   p_package_id integer,
   p_name varchar,
   p_title varchar,
   p_content_type varchar -- default null -> use content_revision

) RETURNS integer AS $$
DECLARE
  v_item_id integer;
  v_revision_id integer;
  v_folder_id integer;
BEGIN
  if p_item_id is null then
      v_item_id := acs_object__new(null, 'content_item', now(), null, null, p_package_id);
  else 
      v_item_id := acs_object__new(p_item_id, 'content_item', now(), null, null, p_package_id);
  end if;

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
  values (v_revision_id, v_item_id, p_title, now(), 'text/enhanced');

  update cr_items set live_revision = v_revision_id
                  where item_id = v_item_id;

  return 1;
END;

$$ LANGUAGE plpgsql;
 


select define_function_args('etp__create_extlink','item_id;null,package_id,url,title,description');

--
-- procedure etp__create_extlink/5
--
CREATE OR REPLACE FUNCTION etp__create_extlink(
   p_item_id integer,
   p_package_id integer,
   p_url varchar,
   p_title varchar,
   p_description varchar
) RETURNS integer AS $$
DECLARE
  v_item_id integer;
  v_folder_id integer;
BEGIN
      v_item_id := acs_object__new(p_item_id, 'content_extlink');
      v_folder_id := etp__get_folder_id(p_package_id);
    
      insert into cr_items (
        item_id, parent_id, name, content_type
      ) values (
        v_item_id, v_folder_id, 'extlink ' || nextval('t_etp_auto_page_number_seq'), 'content_extlink'
      );
      insert into cr_extlinks
        (extlink_id, url, label, description)
      values
        (v_item_id, p_url, p_title, p_description);
    
  return 1;
END;
$$ LANGUAGE plpgsql;

--
-- procedure etp__create_extlink/4
--
CREATE OR REPLACE FUNCTION etp__create_extlink(
   p_package_id integer,
   p_url varchar,
   p_title varchar,
   p_description varchar
) RETURNS integer AS $$
DECLARE
  v_item_id integer;
  v_folder_id integer;
BEGIN
  return etp__create_extlink(null::integer, p_package_id, p_url, p_title, p_description);
END;
$$ LANGUAGE plpgsql;


select define_function_args('etp__create_symlink','package_id,target_id');
--
-- procedure etp__create_symlink/2
--
CREATE OR REPLACE FUNCTION etp__create_symlink(
   p_package_id integer,
   p_target_id integer
) RETURNS integer AS $$
DECLARE
  v_item_id integer;
  v_folder_id integer;
BEGIN
  v_item_id := acs_object__new(null, 'content_symlink');
  v_folder_id := etp__get_folder_id(p_package_id);

  insert into cr_items (
    item_id, parent_id, name, content_type
  ) values (
    v_item_id, v_folder_id, 'symlink ' || nextval('t_etp_auto_page_number_seq'), 'content_symlink'
  );

  insert into cr_symlinks
    (symlink_id, target_id)
  values
    (v_item_id, p_target_id);

  return 1;
END;

$$ LANGUAGE plpgsql;




--
-- procedure etp__create_new_revision/3
--
CREATE OR REPLACE FUNCTION etp__create_new_revision(
   p_package_id integer,
   p_name varchar,
   p_user_id integer
) RETURNS integer AS $$
DECLARE
  v_revision_id integer;
  v_item_id integer;
  v_new_revision_id integer;
  v_content_type varchar;
BEGIN

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

  select nextval('t_acs_object_id_seq')
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
END;

$$ LANGUAGE plpgsql;



select define_function_args('etp__create_new_revision','package_id,name,user_id,revision_id');
--
-- procedure etp__create_new_revision/4
--
CREATE OR REPLACE FUNCTION etp__create_new_revision(
   p_package_id integer,
   p_name varchar,
   p_user_id integer,
   p_revision_id integer
) RETURNS integer AS $$
DECLARE
  v_revision_id integer;
  v_item_id integer;
  v_content_type varchar;
BEGIN

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


  insert into acs_objects (object_id, object_type, creation_date, creation_user, context_id)
  values (p_revision_id, v_content_type, now(), p_user_id, v_item_id);

  insert into cr_revisions (revision_id, item_id, title, description, content, mime_type) 
  select p_revision_id, item_id, title, description, content, mime_type
    from cr_revisions r
   where r.revision_id = v_revision_id;

  -- copy extended attributes to the new revision, if there are any
  insert into acs_attribute_values (object_id, attribute_id, attr_value)
  select p_revision_id as object_id, attribute_id, attr_value
    from acs_attribute_values
   where object_id = v_revision_id;

  return 1;
END;

$$ LANGUAGE plpgsql;




select define_function_args('etp__get_folder_id','package_id');
--
-- procedure etp__get_folder_id/1
--
CREATE OR REPLACE FUNCTION etp__get_folder_id(
   p_package_id integer
) RETURNS integer AS $$
DECLARE
    v_folder_id integer;
    v_parent_id integer;
BEGIN
    select folder_id into v_folder_id
      from cr_folders
     where package_id = p_package_id;
    if not found then 
        select parent_id into v_parent_id
          from site_nodes
         where object_id = p_package_id;
        if found and v_parent_id is null then
            v_folder_id := content_item__get_root_folder(null);
        else
            -- This is probably an ETP app instance that
            -- was created through the Site Map; by returning
	    -- 0 we ensure the get_page_attributes query will
	    -- fail and index.vuh will redirect to etp-setup-2.
            v_folder_id := 0;
        end if;
    end if;

    return v_folder_id;
END;

$$ LANGUAGE plpgsql;




select define_function_args('etp__get_relative_url','item_id,name');
--
-- procedure etp__get_relative_url/2
--
CREATE OR REPLACE FUNCTION etp__get_relative_url(
   p_item_id integer,
   p_name varchar
) RETURNS varchar AS $$
DECLARE
  v_item_id integer;
  v_url varchar;
  v_object_type varchar;
  v_link_rec record;
BEGIN

  select object_type into v_object_type
    from acs_objects
   where object_id = p_item_id;

  if v_object_type = 'content_item' then
    return p_name;
  end if;

  if v_object_type = 'content_folder' then
    select s.name || '/' into v_url
    from cr_folders f, site_nodes s
    where f.folder_id = p_item_id
    and s.object_id = f.package_id;
    return v_url;
  end if;

  if v_object_type = 'content_extlink' then
    select url into v_url
      from cr_extlinks
     where extlink_id = p_item_id;
    return v_url;
  end if;

  if v_object_type = 'content_symlink' then
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

END;

$$ LANGUAGE plpgsql;




select define_function_args('etp__get_title','item_id,revision_title');
--
-- procedure etp__get_title/2
--
CREATE OR REPLACE FUNCTION etp__get_title(
   p_item_id integer,
   p_revision_title varchar
) RETURNS varchar AS $$
DECLARE
  v_item_id integer;
  v_title varchar;
  v_object_type varchar;
BEGIN
  if p_revision_title is not null then
    return p_revision_title;
  end if;

  select object_type from acs_objects into v_object_type
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
    select target_id into v_item_id
      from cr_symlinks
     where symlink_id = p_item_id;
    return etp__get_title(v_item_id, null);
  end if;

  if v_object_type = 'content_item' then
    select r.title into v_title
      from cr_items i, cr_revisions r
     where i.item_id = v_item_id
       and i.live_revision = r.revision_id;
    return v_title;
  end if;  
   
  return null;

END;

$$ LANGUAGE plpgsql;



select define_function_args('etp__get_description','item_id,revision_description');
--
-- procedure etp__get_description/2
--
CREATE OR REPLACE FUNCTION etp__get_description(
   p_item_id integer,
   p_revision_description varchar
) RETURNS varchar AS $$
DECLARE
  v_item_id integer;
  v_description varchar;
  v_object_type varchar;
BEGIN
  if p_revision_description is not null then
    return p_revision_description;
  end if;

  select object_type from acs_objects into v_object_type
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
    select target_id into v_item_id
      from cr_symlinks
     where symlink_id = p_item_id;
    return etp__get_description(v_item_id, null);
  end if;

  if v_object_type = 'content_item' then
    select r.description into v_description
      from cr_items i, cr_revisions r
     where i.item_id = v_item_id
       and i.live_revision = r.revision_id;
    return v_description;
  end if;  

  return null;

END;
$$ LANGUAGE plpgsql;





-- create a folder with magic folder_id of -400 where we
-- will put all deleted content items so they'll be recoverable.

CREATE OR REPLACE FUNCTION inline_1(

) RETURNS integer AS $$
DECLARE
  v_folder_id integer;
BEGIN
select folder_id into v_folder_id from cr_folders where folder_id = -400;
if not found then 
  perform content_folder__new (
    'trash',
    'Trash', 
    'Deleted content items get put here',
    0,
    null,
    -400,
    now(),
    null,
    null
  );
end if;
return 0;
END;

$$ LANGUAGE plpgsql;

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

-- Include the search service contract implementation (olah)
\i edit-this-page-sc-create.sql
