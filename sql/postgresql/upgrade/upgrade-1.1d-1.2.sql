-- upgrade from 1.0.1 to 1.1b
-- dave@thedesignexperience.org
-- 2002-01-24

-- This fixes the content type on all the existing revisions
-- It does this by making them all etp_page_revision
-- If you have custom types, you will need to fix those
-- To do that change the cr_items.content_type to your custom type
-- for the cr_items
-- and change acs_objects.object_type to your custom type for the cr_revisions.

-- If you have any other items with a NULL content_type this will capture them
-- Please confirm and test this before running on a production database.


select content_type__create_type (
        'etp_page_revision',        -- content_type
	'content_revision',         -- supertype
	'ETP managed page',       -- pretty_name
	'ETP managed pages',      -- pretty_plural
	'etp_page_revisions',            -- table_name
	'etp_page_revision_id',              -- id_column
	'content_revision__revision_name'  -- name_method
);


update cr_items set content_type='etp_page_revision' where content_type is NULL;

-- this is untested DAVEB
update acs_objects set object_type='etp_page_revision'
    where exists
	(select 1 from cr_revisions cr, cr_items ci
	 where cr.item_id=ci.item_id
	 and ci.content_type='etp_page_revision'
	 and cr.revision_id=object_id);

-- this function correctly sets the actual content type specificed
-- in the type definition

create or replace function etp__create_page(integer, varchar, varchar, varchar)
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

create or replace function etp__get_description(integer, varchar)
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

create or replace function etp__get_title(integer, varchar)
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

\i ../edit-this-page-sc-create.sql