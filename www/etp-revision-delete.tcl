# /packages/edit-this-page/www/etp-revision-delete.tcl

ad_page_contract {
    @author Lars Pind (lars@pinds.com)
    @creation-date 2003-03-28

    Asks for confirmation before deleting an unpublished revision
} {
    name
    revision_id:integer
    version_number:integer
    {confirmed "f"}
} -properties {
    name:onevalue
    revision_count:onevalue
    version_number:onevalue
    revision_id:onevalue
    form_vars:onevalue
}

etp::check_write_access

set package_id [ad_conn package_id]

if {$confirmed eq "t"} {

    db_exec_plsql delete_revision {}

    ad_returnredirect "etp?[export_url_vars name]"
    ad_script_abort
} else {
    set form_vars [export_vars -form { name revision_id version_number { confirmed t }}]
}
