# /packages/edit-this-page/www/etp-setup.tcl

ad_page_contract {
    @author Luke Pond (dlpond@pobox.com)
    @creation-date 2001-06-01

    Swaps the page with the given sort order 
    with the one preceding it.

} {
    sort_order
}

etp::check_write_access

set sort_key $sort_order

set package_id [ad_conn package_id]

db_foreach get_prev_key "" {
    set prev_sort_key $tree_sortkey
    break;
}

db_transaction {

db_foreach get_all_keys "" {

    if {[regsub "^$prev_sort_key" $tree_sortkey $sort_key new_sortkey] ||
        [regsub "^$sort_key" $tree_sortkey $prev_sort_key new_sortkey]} {

        # fortunately tree_sortkey is not unique, so it doesn't matter
        # if we temporarily have two rows with the same key here.

        db_dml update_key ""

    } else {
	# because of how we ordered the select, we're done.
	# db_foreach will flush the remaining result rows.
	break
    }
}

}

ad_returnredirect "etp"