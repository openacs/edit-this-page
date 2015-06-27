ad_page_contract {
    @author Luke Pond (dlpond@museatech.net)
    @creation-date 2001-06-10

    Handles the form submission and creates a new content page

} {
    name
    title
}

etp::check_write_access

if { [regexp {[^a-zA-Z0-9\-_]} $name] } {
    ad_return_complaint 1 "The subtopic name must be a short identifier
    containing no spaces.  It will be the final part of the URL that 
    identifies this subtopic."
} else {
    etp::make_page $name $title
    ad_returnredirect [export_vars -base etp {name}]
}
