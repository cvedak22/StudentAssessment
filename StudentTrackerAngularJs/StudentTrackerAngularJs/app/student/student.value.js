(function () {
    'use strict';
 
    angular
        .module('studentApp')
        .value('StudentModel', StudentModel);
 
    function StudentModel() {
        this.id = 0;
        this.name = '';
        this.university = '';
        this.country = '';
        this.sex = '';
        this.age = '';
        this.startDate = '';
        this.degree = '';
    }
 
    StudentModel.prototype = {
        toObject: function (data) {
            this.id = data.id;
            this.name = data.firstName + ' ' + data.lastName;
            this.university = data.university;
            this.country = data.country;
            this.sex = data.sex;
            this.age = data.age;
            this.startDate = data.startDate;
            this.degree = data.degree;
            return this;
        }
    }
 
})();
