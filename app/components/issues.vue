<template>
    <div class="row">
        <div class="col-md-11">
            <div>
                <ol class="breadcrumb">
                    <li><a href="#/projects">projects</a></li>
                    <li class="active">{{selected_project.name}}</li>
                </ol>
            </div>
        </div>
        <div class="col-md-1">
            <button type="button" class="btn btn-default" title="Reload issues" v-on="click: refresh_issues">
                <span class="glyphicon glyphicon-refresh"></span>
            </button>
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
                            <table class="table">
                                <tbody>
                                    <tr>
                                        <td class="col-md-2">トラッカ</td>
                                        <td>{{tracker.name}}</td>
                                    </tr>
                                    <tr>
                                        <td>ステータス</td>
                                        <td>{{status.name}}</td>
                                    </tr>
                                    <tr>
                                        <td>優先度</td>
                                        <td>{{priority.name}}</td>
                                    </tr>
                                    <tr>
                                        <td>作成者</td>
                                        <td>{{author.name}}</td>
                                    </tr>
                                    <tr v-if="assigned_to">
                                        <td>担当者</td>
                                        <td>{{assigned_to.name}}</td>
                                    </tr>
                                    <tr v-if="category">
                                        <td>カテゴリ</td>
                                        <td>{{category.name}}</td>
                                    </tr>
                                    <tr v-if="fixed_version">
                                        <td>対象バージョン</td>
                                        <td>{{fixed_version.name}}</td>
                                    </tr>
                                    <tr>
                                        <td>作成日時</td>
                                        <td>{{created_on}}</td>
                                    </tr>
                                    <tr>
                                        <td>更新日時</td>
                                        <td>{{updated_on}}</td>
                                    </tr>
                                </tbody>
                            </table>
                            <pre>{{description}}</pre>
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
            var pid = app.selected_project['id'];
            req
                .get(this.base_url + '/projects/'+pid+'/issues.json')
                .set('Accept', 'application/json')
                .end(function(err, res) {
                    if (err) {
                        console.log(err);
                    } else {
                        app.issues.splice(0, app.issues.length);
                        res.body.issues.forEach(function(i) {
                            app.issues.push(i);
                        });
                    }
                });
        }
    }
};
</script>
