# /packages/edit-this-page/templates/article-index.tcl

ad_page_contract {
    @author Luke Pond (dlpond@pobox.com)
    @creation-date 2001-06-01

    This is the default page used to display content pages
    for an Edit This Page package instance.  It assumes a 
    content type with no extended attributes, and presents
    the content item with a standard article layout.
    <p>
    If you want to use some other page instead, specify it with 
    the content_template package parameter.

} {
} -properties {
    pa:onerow
}

etp::get_page_attributes

