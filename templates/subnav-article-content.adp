<master src="../www/etp-master">
<property name="title">@pa.title;noquote@</property>
<property name="context">@pa.context;noquote@</property>

      <div id="subnavbar-div">
        <div id="subnavbar-container">
          <div id="subnavbar">
            <multiple name="content_items">
              <if @pa_name@ eq @content_items.name@>
                <div class="tab" id="subnavbar-here">
                    <a href="@content_items.name@" title="@content_items.title@">@content_items.title@</a>
                </div>
              </if>
              <else>
                <div class="tab">
                    <a href="@content_items.name@" title="@content_items.title@">@content_items.title@</a>
                </div>
              </else>
            </multiple>
          </div>
        </div>
      </div>
      <div id="subnavbar-body">

@pa.content;noquote@
