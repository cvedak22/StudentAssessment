(function () {
    'use strict';

    angular
        .module('app.common')
        .factory('common', common);

    common.$inject = ['$http'];

    function common($http) {
        var service = {
            $http: $http
            , transform: transform
        };

        return service;

        function transform(jsonResult, constructor, user, propertyName) {
            if (angular.isArray(jsonResult)) {
                var models = [];
                angular.forEach(jsonResult, function (object) {
                    models.push(transformObject(object, constructor, user, propertyName));
                });
                return models;
            } else {
                return transformObject(jsonResult, constructor, user, propertyName);
            }
        }

        function transformObject(jsonResult, constructor, user, propertyName) {
            var model = new constructor();
            model.toObject(jsonResult, user, propertyName);
            return model;
        }

    }
})();