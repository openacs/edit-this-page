ad_page_contract {
    @author Luke Pond (dlpond@museatech.net)
    @creation-date 2001-06-10

    Presents a simple form for creating a new content page

} {
} -properties {
    new_page_name
    page_title
    context
}

etp::check_write_access

set auto_page_name [etp::get_application_param auto_page_name]

if {$auto_page_name eq "number"} {
    set new_page_name [db_nextval etp_auto_page_number_seq]
} elseif {$auto_page_name =="date"} {
    set new_page_name [ns_fmttime [ns_time] "%Y%m%d"]
} else {
    set new_page_name ""
}

set page_title "Create a new content page"
set context [list [list "etp" "[_ acs-kernel.common_Edit]"] "[_ edit-this-page.New_page]"]
