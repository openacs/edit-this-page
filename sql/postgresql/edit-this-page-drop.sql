-- edit-this-page-drop.sql
-- @author Jon Griffin (jon@mayuli.com)
-- @creation-date 2001-11-01
--

drop sequence t_etp_auto_page_number_seq;
drop view etp_auto_page_number_seq;
drop function etp__get_attribute_value (integer, integer);
drop function etp__create_page(integer, varchar, varchar, varchar);
drop function etp__create_extlink(integer, varchar, varchar, varchar);
drop function etp__create_symlink(integer, integer);
drop function etp__create_new_revision(integer, varchar, integer);
drop function etp__get_folder_id (integer);
drop function etp__get_relative_url(integer, varchar);
drop function etp__get_title(integer, varchar);
drop function etp__get_description(integer, varchar);


-- can't do this in PG
--alter table cr_folders drop column package_id cascade;

--- 
-- need to unregister parameters here, but the interface to do so is a pain in the ASS
--


-- this will error if any deleted content exists

create function inline_1 () 
returns integer as '
begin
perform content_folder__delete (
    -400
  );
return 0;
end;
' language 'plpgsql';

select inline_1 ();
drop function inline_1 ();
