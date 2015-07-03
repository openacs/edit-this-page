<master src="../www/etp-master">
<property name="doc(title)">@pa.title;literal@</property>
<property name="context">@pa.context;literal@</property>
      <div id="subnavbar-div">
        <div id="subnavbar-container">
          <div id="subnavbar">
            <multiple name="content_items">
                <div class="tab">
                    <a href="@content_items.name@" title="@content_items.title@">@content_items.title@</a>
                </div>
            </multiple>
          </div>
        </div>
      </div>
      <div id="subnavbar-body">

<if @pa.content@ not nil>
@pa.content;noquote@
</if>