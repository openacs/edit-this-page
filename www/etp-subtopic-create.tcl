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
    if { $subtopic_name eq "" ||
         [regexp {[^a-zA-Z0-9\-_]} $subtopic_name] } {
	ad_return_complaint 1 "[_ edit-this-page.The_subtopic_name_must_be_a_short_identifier]"
	ad_script_abort
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
	ad_returnredirect [export_vars -base $subtopic_name/etp-setup-2 {title}]
	ad_script_abort
    }
    ad_script_abort
} else {
    set confirmed "t"
    set form_vars [export_vars -form {confirmed}]
}

set page_title "[_ edit-this-page.Create_a_new_subtopic]"
set context [list [list "etp" "[_ acs-kernel.common_Edit]"] "[_ edit-this-page.New_subtopic]"]
