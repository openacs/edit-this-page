ad_page_contract {
    @author Luke Pond (dlpond@museatech.net)
    @creation-date 2001-07-10

    Presents a simple form for creating or editing an external link.

} {
    { url "" }
    { label "" }
    { description "" }
    { item_id:naturalnum "" }
    { confirmed "f" }
} -properties {
    page_title:onevalue
    context:onevalue
    form_vars:onevalue
}

etp::check_write_access

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

if { $confirmed == "t" } {
    if { $url eq "" || $label eq "" } {
	ad_return_complaint 1 "[_ edit-this-page.You_must_fill_out_all_fields]"
    } else {
	if { $item_id eq "" } {
	    db_exec_plsql create_extlink {

	    }
	} else {
	    db_dml update_extlink {
		update cr_extlinks
		set url = :url, label = :label, description = :description
		where extlink_id = :item_id
	    }
	}
	ad_returnredirect "etp"
	
    }
    ad_script_abort
} else {
    set confirmed "t"
    set form_vars [export_vars -form {item_id confirmed}]

    if {$item_id ne ""} {
	db_1row get_extlink_info {
	    select url, label, description
	    from cr_extlinks 
	    where extlink_id = :item_id
	}
	set page_title "[_ edit-this-page.Edit_an_external_link]"
	set context [list [list "etp" "[_ acs-kernel.common_Edit]"] "[_ edit-this-page.Edit_an_external_link]"]
    } else {
	set page_title "[_ edit-this-page.Create_a_new_external_link]"
	set context [list [list "etp" "[_ acs-kernel.common_Edit]"] "[_ edit-this-page.New_external_link]"]
    }
}

