ad_page_contract {
    @author Luke Pond (dlpond@museatech.net)
    @creation-date 2001-07-10

    Presents a simple form for creating or editing an external link.

} {
    { url "" }
    { label "" }
    { description "" }
    { item_id "" }
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
    if { [empty_string_p $url] || [empty_string_p $label] } {
	ad_return_complaint 1 "You must fill out all fields in this form."
    } else {
	if { [empty_string_p $item_id] } {
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
    set form_vars [export_form_vars item_id confirmed]

    if {![empty_string_p $item_id]} {
	db_1row get_extlink_info {
	    select url, label, description
	    from cr_extlinks 
	    where extlink_id = :item_id
	}
	set page_title "Edit an external link"
	set context [list [list "etp" "Edit"] "Edit external link"]
    } else {
	set page_title "Create a new external link"
	set context [list [list "etp" "Edit"] "New external link"]
    }
}

