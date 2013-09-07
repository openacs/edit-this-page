ad_page_contract {
    @author Luke Pond (dlpond@museatech.net)
    @creation-date 2001-07-10

    Presents a simple form for creating or editing a symbolic link 
    (which is a link to another page or folder in the CMS)

} {
    { target_id "" }
    { item_id "" }
} -properties {
    page_title:onevalue
    context:onevalue
    item_id:onevalue
    all_pages:multirow
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

if { $target_id ne "" } {

    # if the target is a folder, find the item_id for its index page
    if { [db_string get_object_type {
	select object_type from acs_objects
         where object_id = :target_id
    }] eq "content_folder" } {
	set target_id [db_string get_index_id {
	    select item_id from cr_items
             where parent_id = :target_id
               and name = 'index'
	}]
    }

    if { $item_id eq "" } {
	db_exec_plsql create_symlink {
	}
    } else {
	db_dml update_symlink {
	    update cr_symlinks
	    set target_id = :target_id
	    where symlink_id = :item_id
	}
    }
    ad_returnredirect "etp"
    ad_script_abort
} else {

    if {$item_id ne ""} {
	db_1row get_symlink_info {
	    select target_id
	    from cr_symlinks 
	    where symlink_id = :item_id
	}
	set page_title "[_ edit-this-page.Edit_a_link_to_local_content]"
	set context [list [list "etp" "[_ acs-kernel.common_Edit]"] "[_ edit-this-page.Edit_internal_link]"]
    } else {
	set page_title "[_ edit-this-page.Create_a_link_to_local_content]"
	set context [list [list "etp" "[_ acs-kernel.common_Edit]"] "[_ edit-this-page.New_internal_link]"]
    }

    db_multirow all_pages all_pages {
    }

}

