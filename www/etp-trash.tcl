# /packages/edit-this-page/www/etp-trash.tcl

ad_page_contract {
    @author Luke Pond (dlpond@pobox.com)
    @creation-date 2001-07-25

    Moves the item to the "Trash" folder so we can
    recover it later if necessary.  There is no annoying
    confirmation message.

} {
    item_id:integer
}

etp::check_write_access

set package_id [ad_conn package_id]

if {[db_0or1row get_node_id ""]} {
    site_map_unmount_application -delete_p "t" $node_id    
}

db_dml trash_item ""

ad_returnredirect "etp"
ad_script_abort

