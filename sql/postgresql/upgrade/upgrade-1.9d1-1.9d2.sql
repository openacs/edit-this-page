-- Getting right sequences usage in plpsql functions 
-- Avoiding cases where from clause would be automatically added
--
-- @author Victor Guerra (vguerra@wu.ac.at)

create or replace function etp__create_extlink(integer, varchar, varchar, varchar)
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
    v_item_id, v_folder_id, ''extlink '' || nextval(''t_etp_auto_page_number_seq''), ''content_extlink''
  );

  insert into cr_extlinks
    (extlink_id, url, label, description)
  values
    (v_item_id, p_url, p_title, p_description);

  return 1;
end;
' language 'plpgsql';

create or replace function etp__create_symlink(integer, integer)
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
    v_item_id, v_folder_id, ''symlink '' || nextval(''t_etp_auto_page_number_seq''), ''content_symlink''
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

  select nextval(''t_acs_object_id_seq'')
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

create or replace function etp__get_folder_id (integer)
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
end;
' language 'plpgsql';
