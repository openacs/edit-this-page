# /packages/edit-this-page/www/etp-trash.tcl

ad_page_contract {
    @author Luke Pond (dlpond@pobox.com)
    @creation-date 2001-07-25

    Moves the item to the "Trash" folder so we can
    recover it later if necessary.  There is no annoying
    confirmation message.

} {
    item_id:naturalnum,notnull
}

etp::check_write_access

set package_id [ad_conn package_id]

if {![db_0or1row get_node_id ""]} {
    set node_id ""
} else {

    # You can't delete a site node if it has any children 
    if {[llength [site_node::get_children -node_id $node_id]] > 0} {
	ad_return_warning "Unable to delete content section" {
	    Sorry, this subtopic contains other subtopics.
	    You should remove them first; then you'll be able to
	    remove this one.  If Edit This Page isn't showing any
	    subtopics, you may need to use the
	    <a href="/admin/site-map/">Site Map</a>.
	}
	ad_script_abort
    }
}
    


db_transaction {

    if {$node_id ne ""} {
	site_node::unmount -node_id $node_id
	site_node::delete -node_id $node_id
    }

    # If an item with the same name is already in the trash,
    # rename this item to "Copy of foo".
    while {[db_string matching_name ""] > 0} {
	db_dml update_name ""
    }

    db_dml trash_item ""

}
ad_returnredirect "etp"
ad_script_abort

