# etp-custom-init.tcl

ad_library {
    Registers custom content types used by Edit This Page templates. This allows users to keep their own custom templates, without cluttering etp-init.tcl

    @cvs-id $Id$
    @author Malte Sussdorff sussdorff@sussdorff.de
    @creation-date 30 Jan 2004
}

# This is a custom application called asc. It will not work, as the asc-index and acs-content files are not available. 
#If you want to start your own application, take packages/edit-this-page/templates/article-index.tcl/.adp and use this as your template for your own application.

etp::define_application cognovis-homepage {
    index_template                packages/edit-this-page/templates/cognovis-homepage
    index_object_name             "Cognovís Homepage"

    content_template              packages/edit-this-page/templates/cognovis-content
    content_object_name           "Cognovís Content"
    allow_subtopics               t
    allow_extlinks                t
    allow_symlinks                t
    auto_page_name                "number"
}

etp::define_application cognovis-ebene2 {
    index_template                packages/edit-this-page/templates/cognovis-ebene2
    index_object_name             "Cognovís Ebene2"

    content_template              packages/edit-this-page/templates/cognovis-ebene2-content
    content_object_name           "Cognovís Ebene2 Content"
    allow_subtopics               t
    allow_extlinks                t
    allow_symlinks                t
    auto_page_name                "number"
}
