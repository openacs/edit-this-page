# etp-custom-init.tcl

ad_library {
    Registers custom content types used by Edit This Page templates. This allows users to keep their own custom templates, without cluttering etp-init.tcl

    @cvs-id $Id$
    @author Malte Sussdorff sussdorff@sussdorff.de
    @creation-date 30 Jan 2004
}

# This is a custom application called asc. It will not work, as the asc-index and acs-content files are not available. 
#If you want to start your own application, take packages/edit-this-page/templates/article-index.tcl/.adp and use this as your template for your own application.

# etp::define_application asc {
#    index_template                packages/edit-this-page/templates/asc-index
#    index_object_name             "ASC"
#
#    content_template              packages/edit-this-page/templates/asc-content
#    content_object_name           "asc-article"
#
#    allow_subtopics               f
#    allow_extlinks                f
#    allow_symlinks                f
#    auto_page_name                "number"
#}
