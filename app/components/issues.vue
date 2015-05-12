<template>
    <div class="row">
        <div class="col-md-12">
            <div class="pull-right">
                <button type="button" class="btn btn-default" title="Reload issues">
                    <span class="glyphicon glyphicon-refresh"></span>
                </button>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true" v-repeat="issues">
                <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="heading-{{id}}">
                        <h4 class="panel-title">
                            <a
                                data-toggle="collapse"
                                data-parent="#accordion"
                                href="#collapse-{{id}}"
                                aria-expanded="false"
                                aria-controls="collapse-{{id}}">#{{id}} {{subject}}</a>
                        </h4>
                    </div>
                    <div id="collapse-{{id}}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-{{id}}">
                        <div class="panel-body">
                            <pre>{{$data | json 2}}</pre>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
var req = require('superagent');
module.exports = {
    inherit: true,
    data: function() {
        return {
        };
    },
    created: function() {
        this.refresh_issues();
    },
    methods: {
        refresh_issues: function() {
            var app = this;
            // TODO: clear
            req
                .get(this.base_url + '/projects/'+this.project_id+'/issues.json')
                .set('Accept', 'application/json')
                .end(function(err, res) {
                    if (err) {
                        console.log(err);
                    } else {
                        res.body.issues.forEach(function(i) {
                            app.issues.push(i);
                        });
                    }
                });
        }
    }
};
</script>
