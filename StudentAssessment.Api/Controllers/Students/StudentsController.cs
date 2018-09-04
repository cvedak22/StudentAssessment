using StudentAssessment.Services.Students;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;


namespace StudentAssessment.Api.Controllers.Students
{
    [RoutePrefix("api/students")]
    public class StudentsController : ApiController
    {
        private readonly IStudentService _service;

        public StudentsController(IStudentService service)
        {
            _service = service;
        }

        [Route("")]
        [HttpGet]
        [ResponseType(typeof(IStudent))]
        public async Task<IHttpActionResult> GetStudents()
        {
            var result = await _service.GetStudentsAsync();
            return Ok(result);
        }
    }
}