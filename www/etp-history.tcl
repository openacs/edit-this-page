# /packages/edit-this-page/www/etp-history.tcl

ad_page_contract {
    @author Luke Pond (dlpond@pobox.com)
    @creation-date 2001-06-13

    Displays the revision history for a page, allowing you
    to revert to a previous revision.

} {
    name
} -properties {
    page_title:onevalue
    context:onevalue
    name:onevalue
    live_revision_id:onevalue
    revisions:multirow
}

etp::check_write_access

set package_id [ad_conn package_id]

set live_revision_id [etp::get_live_revision_id $package_id $name]

set page_title "Revision history for $name"

if {$name == "index"} {
    set context [list [list "etp?[export_url_vars name]" Edit] "History"]
} else {
    set context [list [list $name $name] [list "etp?[export_url_vars name]" Edit] "History"]
}


db_multirow revisions get_revisions ""

