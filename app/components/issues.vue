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
                                        <td class="col-md-2">トラッカー</td>
                                        <td v-component="dropdown" v-with="model: editing_issue.tracker_id, options: trackers, current: tracker"></td>
                                    </tr>
                                    <tr>
                                        <td>ステータス</td>
                                        <td v-component="dropdown" v-with="model: editing_issue.status_id, options: issue_statuses, current: status"></td>
                                    </tr>
                                    <tr>
                                        <td>優先度</td>
                                        <td v-component="dropdown" v-with="model: editing_issue.priority_id, options: issue_priorities, current: priority"></td>
                                    </tr>
                                    <tr>
                                        <td>作成者</td>
                                        <td>{{author.name}}</td>
                                    </tr>
                                    <tr v-if="assigned_to">
                                        <td>担当者</td>
                                        <td>
                                            <span v-show="!is_editing">{{assigned_to.name}}</span>
                                            <span v-show=" is_editing">
                                                <select v-model="editing_issue.assigned_to_id">
                                                    <option v-repeat="project_memberships" value="{{id}}" v-attr="selected: id == assigned_to.id">{{user.name}}</option>
                                                </select>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr v-if="category">
                                        <td>カテゴリ</td>
                                        <td>
                                            <span v-show="!is_editing">{{category.name}}</span>
                                            <span v-show=" is_editing">
                                                <select v-model="editing_issue.category_id">
                                                    <option v-repeat="issue_categories" value="{{id}}" v-attr="selected: id == category.id">{{name}}</option>
                                                </select>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr v-if="fixed_version">
                                        <td>対象バージョン</td>
                                        <td>
                                            <span v-show="!is_editing">{{fixed_version.name}}</span>
                                            <span v-show=" is_editing">
                                                <select v-model="editing_issue.version_id">
                                                    <option v-repeat="versions" value="{{id}}" v-attr="selected: id == fixed_version.id">{{name}}</option>
                                                </select>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>作成日時</td>
                                        <td>{{created_on | datetime-format LLL}}</td>
                                    </tr>
                                    <tr>
                                        <td>更新日時</td>
                                        <td>{{updated_on | datetime-format LLL}}</td>
                                    </tr>
                                </tbody>
                            </table>
                            <div>
                                <pre v-show="!is_editing">{{description}}</pre>
                                <textarea class="form-control" row="3" v-show=" is_editing" v-model="editing_issue.description"></textarea>
                            </div>
                            <div class="pull-right">
                                <button
                                    type="button" class="btn btn-primary"
                                    v-on="click: edit_issue($index, $data)"
                                    v-show="!is_editing"
                                    >edit</button>
                                <button
                                    type="button" class="btn btn-default"
                                    v-on="click: is_editing = false"
                                    v-show=" is_editing"
                                    >cancel</button>
                                <button
                                    type="button" class="btn btn-primary"
                                    v-on="click: update_issue($index, $data)"
                                    v-show=" is_editing"
                                    >save</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
var req = require('superagent');

var refresh_array = function(src, dst) {
    dst.splice(0, dst.length);
    src.forEach(function(e) { dst.push(e); });
};

module.exports = {
    inherit: true,
    data: function() {
        return {
            trackers: [],
            issue_statuses: [],
            issue_priorities: [],
            project_memberships: [],
            issue_categories: [],
            versions: [],
            is_editing: false,
            editing_issue: {
                tracker_id: -1,
                status_id: -1,
                priority_id: -1,
                assigned_to_id: -1,
                category_id: -1,
                version_id: -1,
                description: null
            }
        };
    },
    created: function() {
        this.refresh_issues();
    },
    components: {
        dropdown: require('./dropdown.vue')
    },
    methods: {
        get_json: function(path) {
            return req.get(this.base_url + path).set('Accept', 'application/json');
        },
        add_issue: function() {
            // TODO: POST -> issues.splice
        },
        edit_issue: function(index, issue) {
            var self = this;
            var pid  = self.selected_project['id'];
            // NOTE: get enabled trackers on the project
            self.get_json('/projects/' + pid + '.json')
                .query({ include: 'trackers' })
                .end(function(err, res) {
                    if (err) {
                        console.log(err);
                    } else {
                        refresh_array(res.body.project.trackers, self.trackers);
                        self.is_editing = true;
                        self.editing_issue.id = issue.id;
                        self.editing_issue.tracker_id = issue.tracker.id;
                        self.editing_issue.status_id = issue.status.id;
                        self.editing_issue.priority_id = issue.priority.id;
                        if (issue.assigned_to) {
                            self.editing_issue.assigned_to_id = issue.assigned_to.id;
                        }
                        if (issue.category) {
                            self.editing_issue.category_id = issue.category.id;
                        }
                        if (issue.fixed_version) {
                            self.editing_issue.version_id = issue.fixed_version.id;
                        }
                        self.editing_issue.description = issue.description;
                    }
                });
        },
        update_issue: function(index, issue) {
            var self = this;
            var id = issue.id;
            var edited = JSON.parse(JSON.stringify(this.editing_issue));
            delete edited.id;
            var content = {
                issue: edited
            };
            req
                .put(self.base_url + '/issues/' + id + '.json')
                .set('Content-Type', 'application/json')
                .set('Accept', 'application/json')
                .set('X-Redmine-API-Key', self.api_key)
                .send(content)
                .end(function(err, res) {
                    if (err) {
                        console.log(err);
                    } else {
                        self.is_editing = false;
                        self.get_json('/issues/' + id + '.json')
                            .end(function(err, res) {
                                if (err) {
                                    console.log(err);
                                } else {
                                    self.issues.splice(index, 1, res.body.issue);
                                }
                            });
                    }
                });
        },
        refresh_issues: function() {
            var self = this;
            self.is_editing = false;
            self.get_json('/issue_statuses.json')
                .end(function(err, res) {
                    if (err) {
                        console.log(err);
                    } else {
                        refresh_array(res.body.issue_statuses, self.issue_statuses);
                    }
                });
            self.get_json('/enumerations/issue_priorities.json')
                .end(function(err, res) {
                    if (err) {
                        console.log(err);
                    } else {
                        refresh_array(res.body.issue_priorities, self.issue_priorities);
                    }
                });

            var pid = self.selected_project['id'];
            self.get_json('/projects/' + pid + '/memberships.json')
                .end(function(err, res) {
                    if (err) {
                        console.log(err);
                    } else {
                        refresh_array(res.body.memberships, self.project_memberships);
                    }
                });
            self.get_json('/projects/' + pid + '/issue_categories.json')
                .set('X-Redmine-API-Key', self.api_key)
                .end(function(err, res) {
                    if (err) {
                        console.log(err);
                    } else {
                        refresh_array(res.body.issue_categories, self.issue_categories);
                    }
                });
            self.get_json('/projects/' + pid + '/versions.json')
                .end(function(err, res) {
                    if (err) {
                        console.log(err);
                    } else {
                        refresh_array(res.body.versions, self.versions);
                    }
                });
            // NOTE: GET issues
            self.get_json('/projects/' + pid + '/issues.json')
                .end(function(err, res) {
                    if (err) {
                        console.log(err);
                    } else {
                        refresh_array(res.body.issues, self.issues);
                    }
                });
        }
    }
};
</script>
