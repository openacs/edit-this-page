ad_page_contract {
    @author Luke Pond (dlpond@museatech.net)
    @creation-date 2001-07-10

    Presents a simple form for creating or editing an external link.

} {
    { url "" }
    { title "" }
    { item_id "" }
    { confirmed "f" }
} -properties {
    page_title:onevalue
    context:onevalue
    form_vars:onevalue
}

if { $confirmed eq "t" } {
    if { $subtopic_name eq "" ||
         [regexp {[^a-zA-Z0-9\-_]} $subtopic_name] } {
	ad_return_complaint 1 "The subtopic name must be a short identifier
	containing no spaces.  It will be the final part of the URL that 
	identifies this subtopic."
    } else {
	set new_package_id [subsite::auto_mount_application \
	    -instance_name $subtopic_name \
	    -pretty_name $subtopic_title "edit-this-page"]
	set curr_package_id [ad_conn package_id]
	db_foreach old_package_parameters "" {
	    db_dml copy_parameter ""
	}
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
