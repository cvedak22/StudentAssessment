(function () {
    'use strict';
 
    angular
        .module('studentApp')
        .factory('studentService', studentService);
 
    studentService.$inject = ['common', 'StudentModel', 'RESOURCE_SERVER'];
 
    function studentService(common, StudentModel, RESOURCE_SERVER) {
        var service = {
            getList: getList
        };
 
        return service;
 
        ////////////////
 
        function getList() {
            //var url = 'api/students.json';
            var url = RESOURCE_SERVER + 'api/students';
            // issue a http get request to the Web API service
            return common.$http.get(url)
                .then(function (response) {
                    // transforms the JSON response to a list of StudentModel
                    var data = response.data.length === 0 ? [] : common.transform(response.data, StudentModel);
                    return {
                        students: data
                    };
                });
        }
    }
 
})();