import { request } from '@/service/request';

// =============== Client Begin ===============

/** get client list */
export function fetchGetClientList() {
  return request<Api.Monitor.Client[]>({
    url: '/clients',
    method: 'GET'
  });
}

/** get thread pool list by client */
export function fetchGetThreadPoolListByClient(clientId: string, params?: Api.Monitor.ThreadPoolSearchParams) {
  return request<Api.Monitor.ThreadPoolList>({
    url: `/thread_pool/client/${clientId}/page`,
    method: 'GET',
    params
  });
}

/** get thread pool statistics by client */
export function fetchGetThreadPoolStatisticsByClient(clientId: string) {
  return request<Api.Monitor.ThreadPoolStatistics>({
    url: `/thread_pool/client/${clientId}/statistics`,
    method: 'GET'
  });
}

/** get thread pool real-time metrics by client */
export function fetchGetThreadPoolMetricsByClient(clientId: string) {
  return request<Api.Monitor.ThreadPoolMetrics[]>({
    url: `/thread_pool/client/${clientId}/metrics`,
    method: 'GET'
  });
}

// =============== Client End ===============
