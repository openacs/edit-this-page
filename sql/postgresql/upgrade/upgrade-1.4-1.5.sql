--add new pl/pgsql proc
--Dave Bauer dave@thedesignexperience.org
--2003-09-22

create or replace function etp__create_page(integer, integer, varchar, varchar, varchar)
returns integer as '
declare
  p_item_id alias for $1;	
  p_package_id alias for $2;
  p_name alias for $3;
  p_title alias for $4;
  p_content_type alias for $5;  -- default null -> use content_revision
  v_item_id integer;
  v_revision_id integer;
  v_folder_id integer;
begin
  if p_item_id is null then
      v_item_id := acs_object__new(null, ''content_item'', now(), null, null, p_package_id);
  else 
      v_item_id := acs_object__new(p_item_id, ''content_item'', now(), null, null, p_package_id);
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
  values (v_revision_id, v_item_id, p_title, now(), ''text/html'');

  update cr_items set live_revision = v_revision_id
                  where item_id = v_item_id;

  return 1;
end;
' language 'plpgsql';


create or replace function etp__create_new_revision(integer, varchar, integer, integer)
returns integer as '
declare
  p_package_id alias for $1;
  p_name alias for $2;
  p_user_id alias for $3;
  p_revision_id alias for $4;
  v_revision_id integer;
  v_item_id integer;
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
end;
' language 'plpgsql';
