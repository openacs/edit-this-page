# /packages/edit-this-page/www/etp-setup.tcl

ad_page_contract {
    @author Luke Pond (dlpond@pobox.com)
    @creation-date 2001-06-01

    Swaps the page with the given sort order with the one preceding
    it.

} {
    sort_order:notnull
} -validate {
    is_binary {
        if {![regexp {^[0-1]+$} $sort_order]} {
            ad_complain [_ acs-templating.Invalid_number]
            return
        }
    }
}

etp::check_write_access

set sort_key $sort_order

set package_id [ad_conn package_id]

set folder_id [::etp::get_folder_id $package_id]

set prev_sort_key [db_string get_prev_key {
    select tree_sortkey
    from cr_items
   where parent_id = :folder_id
     and tree_sortkey < :sort_key
   order by tree_sortkey desc
   fetch first 1 rows only
}]

db_transaction {

    db_foreach get_all_keys {
       select tree_sortkey, item_id
         from cr_items
        where tree_sortkey >= :prev_sort_key
        order by tree_sortkey
    } {
        if {[regsub "^$prev_sort_key" $tree_sortkey $sort_key new_sortkey] ||
            [regsub "^$sort_key" $tree_sortkey $prev_sort_key new_sortkey]} {

            #
            # Because tree_sortkey is unique, we need to use this
            # swapping idiom. We assume "0" to be a safe temporary
            # value for a sortkey.
            #
            db_dml c_eq_a_key {
                update cr_items set
                tree_sortkey = '0'
                where tree_sortkey = :new_sortkey
            }

            db_dml a_eq_b_key {
                update cr_items set
                tree_sortkey = :new_sortkey
                where item_id = :item_id
            }

            db_dml b_eq_c_key {
                update cr_items set
                tree_sortkey = :tree_sortkey
                where tree_sortkey = '0'
            }

        } else {
            # because of how we ordered the select, we're done.
            # db_foreach will flush the remaining result rows.
            break
        }
    }

}

ad_returnredirect "etp"
ad_script_abort
