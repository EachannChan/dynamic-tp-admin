<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue';
import { useClientStore } from '@/store/modules/client';
import SvgIcon from '@/components/custom/svg-icon.vue';

interface Props {
  modelValue?: string; // clientId (IP:PORT)
}

interface Emits {
  (e: 'update:modelValue', value: string): void; // clientId
  (e: 'change', client: any): void;
}

const props = defineProps<Props>();
const emit = defineEmits<Emits>();

// 使用全局客户端状态
const clientStore = useClientStore();

// 选中的客户端
const selectedClient = ref<string>(''); // clientId
const loading = ref(false);

// 计算属性：按服务分组的客户端
const groupedClients = computed(() => {
  const groups: { [key: string]: any[] } = {};

  // 处理在线客户端
  clientStore.clients.forEach((client: any) => {
    if (!groups[client.clientName]) {
      groups[client.clientName] = [];
    }
    groups[client.clientName].push(client);
  });

  return groups;
});

// 获取客户端列表
async function getClientList() {
  await clientStore.getClientList();
}

// 刷新客户端列表
async function refreshClientList() {
  loading.value = true;
  try {
    await clientStore.refreshClientList();
  } catch (error) {
    // 处理错误
  } finally {
    loading.value = false;
  }
}

// 处理客户端切换
function handleClientChange(clientId: string) {
  const client = clientStore.clients.find((c: any) => c.clientId === clientId);

  // 只有在线客户端才能被选择
  if (client && client.status === 'online') {
    selectedClient.value = clientId;
    emit('update:modelValue', clientId);
    clientStore.setSelectedClient(client.clientName, client);
    emit('change', client);
  }
}

// 获取客户端状态颜色
function getStatusColor(status: string) {
  return status === 'online' ? 'success' : 'error';
}

// 获取客户端状态文本
function getStatusText(status: string) {
  return status === 'online' ? '在线' : '离线';
}

// 格式化时间
function formatTime(timeString: string) {
  if (!timeString) return '未知';
  try {
    const date = new Date(timeString);
    return date.toLocaleString('zh-CN', {
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit'
    });
  } catch {
    return '未知';
  }
}

// 检查客户端是否可点击（只有在线客户端可选）
function isClientClickable(client: any) {
  return client.status === 'online';
}

// 获取服务状态
function getServiceStatus(serviceName: string) {
  const clients = groupedClients.value[serviceName] || [];
  const hasOnline = clients.some((client: any) => client.status === 'online');
  return hasOnline ? 'online' : 'offline';
}

// 获取服务统计
function getServiceStats(serviceName: string) {
  const clients = groupedClients.value[serviceName] || [];
  const total = clients.length;
  const online = clients.filter((client: any) => client.status === 'online').length;
  const offline = total - online;
  return { total, online, offline };
}

// 监听props变化
watch(
  () => props.modelValue,
  (newValue: string | undefined) => {
    if (newValue && newValue !== selectedClient.value) {
      selectedClient.value = newValue;
    }
  },
  { immediate: true }
);

onMounted(() => {
  getClientList();
});
</script>

<template>
  <NCard title="客户端选择"
         :bordered="false"
         class="mb-4">
    <template #header-extra>
      <NButton size="small"
               :loading="loading"
               @click="refreshClientList">刷新</NButton>
    </template>

    <div v-if="!loading && Object.keys(groupedClients).length === 0"
         class="flex items-center justify-center py-12">
      <NEmpty description="暂无客户端" />
    </div>

    <div v-else
         class="space-y-6">
      <!-- 按服务分组显示 -->
      <div v-for="(clients, serviceName) in groupedClients"
           :key="serviceName"
           class="space-y-3">
        <!-- 服务标题 -->
        <div class="flex items-center justify-between border-b border-gray-200 pb-2">
          <div class="flex items-center space-x-3">
            <div class="flex-shrink-0">
              <div class="h-8 w-8 flex items-center justify-center rounded-full"
                   :class="getServiceStatus(serviceName) === 'online' ? 'bg-green-100' : 'bg-gray-100'">
                <SvgIcon icon="mdi:server"
                         :class="getServiceStatus(serviceName) === 'online' ? 'text-lg text-green-600' : 'text-lg text-gray-400'" />
              </div>
            </div>
            <div>
              <h3 class="text-lg text-gray-900 font-semibold">
                {{ serviceName }}
              </h3>
              <div class="flex items-center text-sm text-gray-500 space-x-4">
                <span>总实例: {{ getServiceStats(serviceName).total }}</span>
                <span class="text-green-600">在线: {{ getServiceStats(serviceName).online }}</span>
                <span class="text-red-600">离线: {{ getServiceStats(serviceName).offline }}</span>
              </div>
            </div>
          </div>
          <NTag :type="getServiceStatus(serviceName) === 'online' ? 'success' : 'error'"
                size="medium">
            {{ getServiceStatus(serviceName) === 'online' ? '在线' : '离线' }}
          </NTag>
        </div>

        <!-- 实例列表 -->
        <div class="grid grid-cols-1 gap-3 lg:grid-cols-2 xl:grid-cols-3">
          <div v-for="client in clients"
               :key="client.clientId"
               class="relative transition-all duration-200 hover:shadow-md"
               :class="[
              selectedClient === client.clientId ? 'ring-2 ring-primary ring-opacity-50' : '',
              isClientClickable(client) ? 'cursor-pointer' : 'cursor-not-allowed opacity-60'
            ]"
               @click="isClientClickable(client) ? handleClientChange(client.clientId) : null">
            <NCard :bordered="true"
                   size="small"
                   class="h-full"
                   :class="[
                selectedClient === client.clientId ? 'border-primary bg-primary-50' : '',
                isClientClickable(client) ? 'hover:border-gray-300' : 'border-gray-200'
              ]">
              <div class="flex items-start space-x-3">
                <div class="flex-shrink-0">
                  <div class="h-8 w-8 flex items-center justify-center rounded-full"
                       :class="client.status === 'online' ? 'bg-green-100' : 'bg-gray-100'">
                    <SvgIcon icon="mdi:monitor"
                             :class="client.status === 'online' ? 'text-sm text-green-600' : 'text-sm text-gray-400'" />
                  </div>
                </div>
                <div class="min-w-0 flex-1">
                  <div class="mb-1 flex items-center justify-between">
                    <h4 class="truncate text-sm font-medium"
                        :class="client.status === 'online' ? 'text-gray-900' : 'text-gray-500'">
                      {{ client.clientIp }}:{{ client.clientPort }}
                    </h4>
                    <NTag :type="getStatusColor(client.status)"
                          size="tiny">
                      {{ getStatusText(client.status) }}
                    </NTag>
                  </div>
                  <div class="text-xs text-gray-400">最后心跳: {{ formatTime(client.lastHeartbeat) }}</div>
                </div>
              </div>
            </NCard>
          </div>
        </div>
      </div>
    </div>
  </NCard>
</template>
