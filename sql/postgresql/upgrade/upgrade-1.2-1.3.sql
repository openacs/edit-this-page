-- changed variable declaration from varchar(400) to varchar

create or replace function etp__get_relative_url(integer, varchar)
returns varchar as '
declare
  p_item_id alias for $1;
  p_name alias for $2;
  v_item_id integer;
  v_url varchar;
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

create or replace function etp__get_title(integer, varchar)
returns varchar as '
declare
  p_item_id alias for $1;
  p_revision_title alias for $2;
  v_item_id integer;
  v_title varchar;
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

create or replace function etp__get_description(integer, varchar)
returns varchar as '
declare
  p_item_id alias for $1;
  p_revision_description alias for $2;
  v_item_id integer;
  v_description varchar;
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
