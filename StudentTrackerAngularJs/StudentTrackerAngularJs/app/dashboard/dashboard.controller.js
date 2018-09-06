(function () {
    'use strict';

    angular
        .module('studentApp')
        .controller('DashboardController', DashboardController);

    DashboardController.$inject = ['initialData'];

    function DashboardController(initialData) {
        var vm = this;

        vm.title = 'Dashboard';
        vm.universities = initialData.totalUniversities;
        vm.countries = initialData.totalCountries;
        vm.students = initialData.totalStudents;

        vm.lineChartOptions = {
            chart: {
                type: 'historicalBarChart',
                height: 500,
                margin: {
                    top: 40,
                    right: 50,
                    bottom: 60,
                    left: 30
                },
                x: function (d) { return d.key; },
                y: function (d) { return d.value; },
                xAxis: {
                    axisLabel: 'Years',
                    rotateLabels: 30
                },
                yAxis: {
                    axisLabel: 'Students',
                    axisLabelDistance: -10
                },
                showLegend: false
            }
        };

        vm.lineChartData = [{
            values: initialData.studentsPerYear,
            color: '#7777ff',
            area: true

        }];

        vm.pieChartOptions = {
            chart: {
                type: 'pieChart',
                height: 500,
                x: function (d) { return d.key; },
                y: function (d) { return d.value; },
                showLabels: true,
                valueFormat: function (d) {
                    return d3.format(',.0f')(d) + ' students';
                },
                duration: 500,
                labelThreshold: 0.01,
                labelSunbeamLayout: true,
                legend: {
                    margin: {
                        top: 5,
                        right: 35,
                        bottom: 5,
                        left: 0
                    }
                }
            }
        };

        vm.pieChartData = initialData.studentsPerCountry;

        activate();

        function activate() {
            console.log(vm.title + ' loaded!');
        }

    }
})();