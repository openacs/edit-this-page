#
#  Copyright (C) 2001, 2002 MIT
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#


# /packages/edit-this-page/www/etp-install-portlet.tcl

ad_page_contract {
    @author Stefan Wurdack (dotlrn@email.wuon.de)

    Creates the initial index page and the entry in cr_folders
    for a new content section like etp-setup-2 and additionally creates a filestorage for webcontent

} {
} 

etp::check_write_access

set package_id [ad_conn package_id]
set node_id [ad_conn node_id]
set data [db_1row get_section_name ""]

set site_node_url [file dirname [ad_conn url]]

    set name [db_string site_node_name ""]
    set parent_url [file dirname $site_node_url]
    set name "$name $package_id"
    array set parent_site_node [site_node::get -url $parent_url]
    set parent_package_id $parent_site_node(object_id)
    db_transaction {
	set folder_id [db_exec_plsql create_folder ""]
	db_exec_plsql register_types ""
	db_exec_plsql register_folders ""
	db_dml set_folder_package ""
	etp::make_page "index" $title
    }
set fs_package_id [site_node::instantiate_and_mount -parent_node_id $node_id -package_key "file-storage" -package_name "file-storage"]
ad_returnredirect "etp"