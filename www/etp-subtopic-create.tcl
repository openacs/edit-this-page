ad_page_contract {
    @author Luke Pond (dlpond@museatech.net)
    @creation-date 2001-07-06

    Presents a simple form for creating a new subtopic.
    Prevents us from having to use the confusing site-map interface.

} {
    { subtopic_name "" }
    { subtopic_title "" }
    { confirmed f }
} -properties {
    page_title:onevalue
    context:onevalue
    form_vars:onevalue
}

etp::check_write_access

if { $confirmed == "t" } {
    if { [empty_string_p $subtopic_name] ||
         [regexp {[^a-zA-Z0-9\-_]} $subtopic_name] } {
	ad_return_complaint 1 "The subtopic name must be a short identifier
	containing no spaces.  It will be the final part of the URL that 
	identifies this subtopic."
    } else {
	set new_package_id [subsite::auto_mount_application \
	    -instance_name $subtopic_name \
	    -pretty_name $subtopic_title "edit-this-page"]
	set curr_package_id [ad_conn package_id]

#       this parameter-copying code predates the use of ETP applications
#	db_foreach old_package_parameters "" {
#	    db_dml copy_parameter ""
#	}

        db_1row get_subtopic_application ""
        db_1row get_application_parameter_id ""
        db_dml set_subtopic_application ""

	apm_parameter_sync "edit-this-page" $new_package_id
	set title $subtopic_title
	ad_returnredirect "$subtopic_name/etp-setup-2?[export_url_vars title]"
    }
    ad_script_abort
} else {
    set confirmed "t"
    set form_vars [export_form_vars confirmed]
}

set page_title "Create a new subtopic"
set context [list [list "etp" "Edit"] "New subtopic"]
