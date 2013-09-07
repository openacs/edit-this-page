# /packages/edit-this-page/www/etp-revert.tcl

ad_page_contract {
    @author Luke Pond (dlpond@pobox.com)
    @creation-date 2001-06-13

    Asks for confirmation before deleting revisions

} {
    name
    revision_id:integer
    version_number:integer
    { confirmed "f" }
} -properties {
    name:onevalue
    revision_count:onevalue
    version_number:onevalue
    revision_id:onevalue
    form_vars:onevalue
}

etp::check_write_access

set package_id [ad_conn package_id]

if { $confirmed eq "t" } {
    db_transaction {
	db_1row get_item_id ""

	db_dml set_live_revision ""
	set revision_list [db_list revisions_to_delete ""]

	foreach revision_id $revision_list {
	    db_exec_plsql delete_revision ""
	}
    }
    ad_returnredirect "etp?[export_url_vars name]"
    ad_script_abort

} else {

    db_1row get_revision_count ""

    set confirmed "t"
    set form_vars [export_form_vars name revision_id version_number confirmed]
}