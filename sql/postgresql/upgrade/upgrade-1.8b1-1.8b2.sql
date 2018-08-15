-- 
-- 
-- 
-- @author Dave Bauer (dave@thedesignexperience.org)
-- @creation-date 2004-12-08
-- @cvs-id $Id$
--

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
' language 'plpgsql' stable;
