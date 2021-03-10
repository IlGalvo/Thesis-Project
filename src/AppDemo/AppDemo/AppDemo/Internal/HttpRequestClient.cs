using AppDemo.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;

namespace AppDemo.Internal
{
    public class HttpRequestClient
    {
        private const string DefaultUrl = "http://192.168.1.5:8000";

        private const string GetConfidenceRules = (DefaultUrl + "?q=confidence_rules");
        private const string GetArteries = (DefaultUrl + "?q=arteries");
        private const string GetComparatorTypes = (DefaultUrl + "?q=comparator_types");
        private const string GetComparatorModes = (DefaultUrl + "?q=comparator_modes");
        private const string GetGeneralTexts = (DefaultUrl + "?q=general_texts");

        private const string PostInsert = (DefaultUrl + "?action=insert");
        private const string PostDelete = (DefaultUrl + "?action=delete");

        private const double DefaultTimeout = 5;

        private static HttpRequestClient instance;
        public static HttpRequestClient Instance { get { instance = (instance ?? new HttpRequestClient()); return instance; } }

        private readonly HttpClient httpClient;

        private HttpRequestClient()
        {
            httpClient = new HttpClient
            {
                Timeout = TimeSpan.FromSeconds(DefaultTimeout)
            };
        }

        private async Task<string> HandleResponseAsync(HttpResponseMessage httpResponseMessage)
        {
            var text = await httpResponseMessage.Content.ReadAsStringAsync().ConfigureAwait(false);

            if (!httpResponseMessage.IsSuccessStatusCode)
            {
                throw (new HttpRequestException(text));
            }

            return text;
        }

        public async Task<List<ConfidenceRule>> GetConfidenceRulesAsync()
        {
            var httpResponseMessage = await httpClient.GetAsync(GetConfidenceRules).ConfigureAwait(false);
            var jsonText = await HandleResponseAsync(httpResponseMessage).ConfigureAwait(false);

            return JsonConvert.DeserializeObject<List<ConfidenceRule>>(jsonText);
        }

        public async Task<List<string>> GetArteriesAsync()
        {
            var httpResponseMessage = await httpClient.GetAsync(GetArteries).ConfigureAwait(false);
            var jsonText = await HandleResponseAsync(httpResponseMessage).ConfigureAwait(false);

            return JsonConvert.DeserializeObject<List<string>>(jsonText);
        }

        public async Task<List<string>> GetComparatorTypesAsync()
        {
            var httpResponseMessage = await httpClient.GetAsync(GetComparatorTypes).ConfigureAwait(false);
            var jsonText = await HandleResponseAsync(httpResponseMessage).ConfigureAwait(false);

            return JsonConvert.DeserializeObject<List<string>>(jsonText);
        }

        public async Task<List<string>> GetComparatorModesAsync()
        {
            var httpResponseMessage = await httpClient.GetAsync(GetComparatorModes).ConfigureAwait(false);
            var jsonText = await HandleResponseAsync(httpResponseMessage).ConfigureAwait(false);

            return JsonConvert.DeserializeObject<List<string>>(jsonText);
        }

        public async Task<List<string>> GetGeneralTextsAsync()
        {
            var httpResponseMessage = await httpClient.GetAsync(GetGeneralTexts).ConfigureAwait(false);
            var jsonText = await HandleResponseAsync(httpResponseMessage).ConfigureAwait(false);

            return JsonConvert.DeserializeObject<List<string>>(jsonText);
        }

        public async Task<ConfidenceRule> InsertAsync(Dictionary<string, string> dictionary)
        {
            using (var formUrlEncoded = new FormUrlEncodedContent(dictionary))
            {
                var httpResponseMessage = await httpClient.PostAsync(PostInsert, formUrlEncoded).ConfigureAwait(false);
                var jsonText = await HandleResponseAsync(httpResponseMessage).ConfigureAwait(false);

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
                var httpResponseMessage = await httpClient.PostAsync(PostDelete, formUrlEncoded).ConfigureAwait(false);

                await HandleResponseAsync(httpResponseMessage).ConfigureAwait(false);
            }
        }
    }
}