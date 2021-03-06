using AppDemo.Models;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;

namespace AppDemo.Internal
{
    public class HttpRequestClient
    {
        private static HttpRequestClient instance;
        public static HttpRequestClient Instance { get { instance = (instance ?? new HttpRequestClient()); return instance; } }

        private readonly HttpClient httpClient;

        private HttpRequestClient()
        {
            httpClient = new HttpClient();
        }

        private async Task<string> HandleResponseAsync(HttpResponseMessage httpResponseMessage)
        {
            var text = await httpResponseMessage.Content.ReadAsStringAsync();

            if (!httpResponseMessage.IsSuccessStatusCode)
            {
                throw (new HttpRequestException(text));
            }

            return text;
        }

        public async Task<List<ConfidenceRule>> GetConfidenceRulesAsync()
        {
            var httpResponseMessage = await httpClient.GetAsync("http://192.168.1.5:8000?q=confidence_rules");
            var jsonText = await HandleResponseAsync(httpResponseMessage);

            return JsonConvert.DeserializeObject<List<ConfidenceRule>>(jsonText);
        }

        public async Task<List<string>> GetArteriesAsync()
        {
            var httpResponseMessage = await httpClient.GetAsync("http://192.168.1.5:8000?q=arteries");
            var jsonText = await HandleResponseAsync(httpResponseMessage);

            return JsonConvert.DeserializeObject<List<string>>(jsonText);
        }

        public async Task<List<string>> GetComparatorTypesAsync()
        {
            var httpResponseMessage = await httpClient.GetAsync("http://192.168.1.5:8000?q=comparator_types");
            var jsonText = await HandleResponseAsync(httpResponseMessage);

            return JsonConvert.DeserializeObject<List<string>>(jsonText);
        }

        public async Task<List<string>> GetComparatorModesAsync()
        {
            var httpResponseMessage = await httpClient.GetAsync("http://192.168.1.5:8000?q=comparator_modes");
            var jsonText = await HandleResponseAsync(httpResponseMessage);

            return JsonConvert.DeserializeObject<List<string>>(jsonText);
        }

        public async Task<List<string>> GetGeneralTextsAsync()
        {
            var httpResponseMessage = await httpClient.GetAsync("http://192.168.1.5:8000?q=general_texts");
            var jsonText = await HandleResponseAsync(httpResponseMessage);

            return JsonConvert.DeserializeObject<List<string>>(jsonText);
        }

        public async Task<ConfidenceRule> InsertAsync(Dictionary<string, string> dictionary)
        {
            using (var formUrlEncoded = new FormUrlEncodedContent(dictionary))
            {
                var httpResponseMessage = await httpClient.PostAsync("http://192.168.1.5:8000?action=insert", formUrlEncoded);
                var jsonText = await HandleResponseAsync(httpResponseMessage);

                return JsonConvert.DeserializeObject<ConfidenceRule>(jsonText);
            }
        }

        public async Task DeleteAsync(int id, string name)
        {
            var dictionary = new Dictionary<string, string>
            {
                { "id", id.ToString() },
                { "name", name }
            };

            using (var formUrlEncoded = new FormUrlEncodedContent(dictionary))
            {
                var httpResponseMessage = await httpClient.PostAsync("http://192.168.1.5:8000?action=delete", formUrlEncoded);

                await HandleResponseAsync(httpResponseMessage);
            }
        }
    }
}