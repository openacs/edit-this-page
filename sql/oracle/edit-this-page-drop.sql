-- etp-create.sql
-- @author Luke Pond (dlpond@pobox.com)
-- @creation-date 2001-05-31
--
-- Ported to Oracle by Jon Griffin and Don Baccus

drop sequence etp_auto_page_number_seq;
--create view etp_auto_page_number_seq as
--select nextval('t_etp_auto_page_number_seq') as nextval;
--- package decs

drop package etp;


declare

  cursor subsite_values is
    select v.value_id
    from apm_parameter_values v, apm_parameters p
    where p.package_key = 'acs-subsite'
      and p.section_name = 'EditThisPage'
      and p.parameter_id = v.parameter_id;

  cursor subsite_parameters is
    select parameter_id
    from apm_parameters
    where package_key = 'acs-subsite'
      and section_name = 'EditThisPage';

begin
  for cur_val in subsite_values loop
      apm_parameter_value.delete (
        value_id           => cur_val.value_id
      );
  end loop;   

  for cur_val in subsite_parameters loop
      apm.unregister_parameter(
         parameter_id        => cur_val.parameter_id
      );
  end loop;
end;
/
show errors;

begin
  content_folder.delete (
           folder_id      => -400
  );
end;
/
show errors;
