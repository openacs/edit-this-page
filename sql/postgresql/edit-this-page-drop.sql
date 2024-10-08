-- edit-this-page-drop.sql
-- @author Jon Griffin (jon@mayuli.com)
-- @creation-date 2001-11-01
--

drop view etp_auto_page_number_seq;
drop sequence t_etp_auto_page_number_seq;
drop function etp__get_attribute_value (integer, integer);
drop function etp__create_page(integer, varchar, varchar, varchar);
drop function etp__create_extlink(integer, varchar, varchar, varchar);
drop function etp__create_symlink(integer, integer);
drop function etp__create_new_revision(integer, varchar, integer);
drop function etp__get_folder_id (integer);
drop function etp__get_relative_url(integer, varchar);
drop function etp__get_title(integer, varchar);
drop function etp__get_description(integer, varchar);

create function inline_0 () 
returns integer as '
declare
  v_cur_val record;
begin
  for v_cur_val in
    select v.value_id
    from apm_parameter_values v, apm_parameters p
    where p.package_key = ''acs-subsite''
      and p.section_name = ''EditThisPage''
      and p.parameter_id = v.parameter_id
  loop
      perform apm_parameter_value__delete (v_cur_val.value_id);
  end loop;   

  for v_cur_val in
    select parameter_id
    from apm_parameters
    where package_key = ''acs-subsite''
      and section_name = ''EditThisPage''
  loop
      perform apm__unregister_parameter(v_cur_val.parameter_id);
  end loop;
  return 0;
end;' language 'plpgsql';

select inline_0 ();
drop function inline_0 ();

-- although we don't attempt to delete content that was
-- added via ETP, in order to delete the package we must
-- remove the package reference from cr_folders that were
-- created by ETP
update cr_folders set package_id = null
where package_id in (select package_id 
                       from apm_packages
                      where package_key = 'edit-this-page');

-- also kill the package reference in the context_id field
-- of ETP content
update acs_objects set context_id = 0
where context_id in (select package_id 
                       from apm_packages
                      where package_key = 'edit-this-page');

