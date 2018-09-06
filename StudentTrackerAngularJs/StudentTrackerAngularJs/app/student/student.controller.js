(function () {
    'use strict';
 
    angular
        .module('studentApp')
        .controller('StudentController', StudentController);
 
        StudentController.$inject = ['initialData'];
 
    function StudentController(initialData) {
        var vm = this;
 
        vm.title = 'Students';
        /* Initialize vm.* bindable members with initialData.* members */
        vm.students = initialData.students;
 
        activate();
 
        ////////////////
 
        function activate() {
            console.log(vm.title + ' loaded!');
        }
 
    }
})();