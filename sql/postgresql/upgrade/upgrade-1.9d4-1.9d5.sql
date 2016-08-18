select define_function_args('etp__get_attribute_value','object_id,attribute_id');
select define_function_args('etp__create_extlink','item_id;null,package_id,url,title,description');
select define_function_args('etp__create_symlink','package_id,target_id');
select define_function_args('etp__get_folder_id','package_id');
select define_function_args('etp__create_new_revision','package_id,name,user_id,revision_id');
select define_function_args('etp__get_relative_url','item_id,name');
select define_function_args('etp__get_title','item_id,revision_title');
select define_function_args('etp__get_description','item_id,revision_description');
select define_function_args('etp__create_page','item_id,package_id,name,title,content_type;null');

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

