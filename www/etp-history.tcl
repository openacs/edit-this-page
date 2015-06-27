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

set page_title [_ edit-this-page.revision_history_for]

if {$name eq "index"} {
    set context [list [list [export_vars -base etp {name}] "[_ acs-kernel.common_Edit]"] "[_ edit-this-page.History]"]
} else {
    set context [list [list $name $name] [list [export_vars -base etp {name}] "[_ acs-kernel.common_Edit]"] "[_ edit-this-page.History]"]
}


db_multirow revisions get_revisions ""

