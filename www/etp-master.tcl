# /packages/edit-this-page/www/master.tcl

# Ensures variables needed by master.adp are defined

if { ![info exists title] } {
    set title [ad_system_name]
}	
if { ![info exists context] } {
    set context ""
}	
if { ![info exists signatory] } {
    set signatory [ad_system_owner]
}

set filename [file tail [ad_conn url]]
if { $filename ne "etp*"  } {
    set etp_link [etp::get_etp_link]
} else {
    set etp_link ""
}
