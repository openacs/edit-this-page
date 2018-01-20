ad_page_contract {
    @author Luke Pond (dlpond@museatech.net)
    @creation-date 2001-06-04

    Displays all options for editing a page

} {
    name
}

etp::check_write_access

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

set latest_revision_id [etp::get_latest_revision_id $package_id $name]
set live_revision_id [etp::get_live_revision_id $package_id $name]

if { $latest_revision_id > $live_revision_id } {
    db_transaction {
	db_dml publish_latest_revision ""
	db_dml set_publish_date ""
	db_dml set_audit_info ""
    }
    # Invalidate the cache used by etp::get_page_attributes
    set key "etp::get_pa $package_id $name [etp::get_content_type $name]"
    ns_log Notice "etp-publish: invalidating cache for $key"
    util_memoize_flush $key
}

ad_returnredirect [export_vars -base etp {name}]
ad_script_abort
