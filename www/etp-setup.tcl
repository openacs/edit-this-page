# /packages/edit-this-page/www/etp-setup.tcl

ad_page_contract {
    @author Luke Pond (dlpond@pobox.com)
    @creation-date 2001-06-01

    This page allows admins to perform initial setup 
    of a new content section.

} {
    {page_title ""}
    {confirmed "f"}
    {app ""}
    {subtopic_app ""}
} -properties {
    app_options:onevalue
    subtopic_app_options:onevalue
    context_bar:onevalue
}

etp::check_write_access

set package_id [ad_conn package_id]

if { $confirmed == "f" } {
    set app [ad_parameter application "default"]
    set subtopic_app [ad_parameter subtopic_application "default"]

    set app_options ""
    set subtopic_app_options ""

    set apps [etp::get_defined_applications]

    foreach app_name $apps {
	
	if { $app == $app_name } {
	    append app_options "<option value=\"$app_name\" selected>$app_name</option>\n"
	} else {
	    append app_options "<option value=\"$app_name\">$app_name</option>\n"
	}
	
	if { $subtopic_app == $app_name } {
	    append subtopic_app_options "<option value=\"$app_name\" selected>$app_name</option>\n"
	} else {
	    append subtopic_app_options "<option value=\"$app_name\">$app_name</option>\n"
	}
    }
    set page_title "Change ETP application in use for content section \"$page_title\""
    set context_bar [ad_context_bar {"etp" "Edit"} "Setup"]
    
    ad_return_template

} else {
    db_dml set_app_param ""
    db_dml set_subtopic_app_param ""
    apm_parameter_sync edit-this-page $package_id
    ad_returnredirect "etp"
    ad_script_abort
}


