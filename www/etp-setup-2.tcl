# /packages/edit-this-page/www/etp-setup-2.tcl

ad_page_contract {
    @author Luke Pond (dlpond@pobox.com)
    @creation-date 2001-06-01

    Creates the initial index page and the entry in cr_folders
    for a new content section.

} {
} 

etp::check_write_access

set package_id [ad_conn package_id]
set node_id [ad_conn node_id]
db_1row get_section_name ""

set site_node_url [file dirname [ad_conn url]]

if { $site_node_url == "/" } {
    # -100 is the magic number for the "root folder".
    set folder_id -100
    db_transaction {
	db_dml set_folder_package ""
	etp::make_page "index" $title
    }

} else {
    set name [db_string site_node_name ""]
    set parent_url [file dirname $site_node_url]

    array set parent_site_node [site_node::get -url $parent_url]
    set parent_package_id $parent_site_node(object_id)

#    set parent_package_id [site_node_closest_ancestor_package -url "$parent_url" "edit-this-page"]
#    if {[empty_string_p $parent_package_id]} {
#	set parent_package_id [site_node_closest_ancestor_package -url "$parent_url" "acs-subsite"]
#    }

    db_transaction {
	set folder_id [db_exec_plsql create_folder ""]
	db_exec_plsql register_types ""
	db_exec_plsql register_folders ""
	db_dml set_folder_package ""
	etp::make_page "index" $title
    }
}

ad_returnredirect "etp"
