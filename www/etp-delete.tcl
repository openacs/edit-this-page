# /packages/edit-this-page/www/etp-delete.tcl

ad_page_contract {
    @author Luke Pond (dlpond@pobox.com)
    @creation-date 2001-06-13

    Asks for confirmation before deleting the whole page

} {
    name
    { confirmed f }
} -properties {
    page_url:onevalue
    title:onevalue
    form_vars:onevalue
}

etp::check_write_access

set package_id [ad_conn package_id]

if { $confirmed == "t" } {
    # TODO: the clear_revisions statement below should be unnecessary.
    # It's there because content_item__delete was throwing an error
    # (possibly due to the data-change violation, basically a postgresql bug)
    db_1row get_item_id ""
    db_dml clear_revisions ""
    db_exec_plsql delete_page ""
    ad_returnredirect "etp"
    ad_script_abort
} else {
    set confirmed "t"
    set form_vars [export_form_vars name confirmed]
    set page_url "[file dirname [ad_conn url]]/$name"
    db_0or1row get_title "" 
    if {![info exists title]} {
	set title "Unknown title"
    }
}