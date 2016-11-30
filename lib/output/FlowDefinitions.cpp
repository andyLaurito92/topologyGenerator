#include "FlowDefinitions.h" 

std::multimap<std::string, std::shared_ptr<Flow>> FlowDefinitions::Flows; 

void FlowDefinitions::defineFlows(){ 


	 ///// definition of flow Flow0_1 
	 auto flowFlow0_1PeriodDistribution = readDistributionParameter("flowFlow0_1.periodDistribution"); 
	 auto flowFlow0_1PacketSizeDistribution = readDistributionParameter("flowFlow0_1.packetSizeDistribution"); 
	 auto flowFlow0_1 = std::make_shared<Flow>("Flow0_1", 0 /*startTime*/, 0 /*typeOfService*/, flowFlow0_1PeriodDistribution, flowFlow0_1PacketSizeDistribution); 
	 // routes for flow Flow0_1 
	 auto flowFlow0_1_route0 = std::make_shared<Route>( std::deque<Route::Node>{ 
			 {0, "lar_felix_0.Routing"}, 
			 {2, "lar_switch_01.Routing"}, 
			 {0, "lar_swrod_0.Routing"} 
	 });	 
	 auto flowFlow0_1_route1 = std::make_shared<Route>( std::deque<Route::Node>{ 
			 {1, "lar_felix_0.Routing"}, 
			 {2, "lar_switch_02.Routing"}, 
			 {1, "lar_swrod_0.Routing"} 
	 });	 
	 // register flow Flow0_1 with its routes
	 FlowDefinitions::registerFlowSourceNode(flowFlow0_1, "lar_felix_0.GeneratorApplication");  
	 FlowDefinitions::registerFlowRoute(flowFlow0_1, flowFlow0_1_route0);  
	 FlowDefinitions::registerFlowRoute(flowFlow0_1, flowFlow0_1_route1);  
	 

	 ///// definition of flow Flow_Monitoring0_1 
	 auto flowFlow_Monitoring0_1PeriodDistribution = readDistributionParameter("flowFlow_Monitoring0_1.periodDistribution"); 
	 auto flowFlow_Monitoring0_1PacketSizeDistribution = readDistributionParameter("flowFlow_Monitoring0_1.packetSizeDistribution"); 
	 auto flowFlow_Monitoring0_1 = std::make_shared<Flow>("Flow_Monitoring0_1", 0 /*startTime*/, 0 /*typeOfService*/, flowFlow_Monitoring0_1PeriodDistribution, flowFlow_Monitoring0_1PacketSizeDistribution); 
	 // routes for flow Flow_Monitoring0_1 
	 auto flowFlow_Monitoring0_1_route0 = std::make_shared<Route>( std::deque<Route::Node>{ 
			 {0, "lar_felix_0.Routing"}, 
			 {2, "lar_switch_01.Routing"}, 
			 {0, "lar_swrod_0.Routing"} 
	 });	 
	 // register flow Flow_Monitoring0_1 with its routes
	 FlowDefinitions::registerFlowSourceNode(flowFlow_Monitoring0_1, "lar_felix_0.GeneratorApplication");  
	 FlowDefinitions::registerFlowRoute(flowFlow_Monitoring0_1, flowFlow_Monitoring0_1_route0);  
	 

	 ///// definition of flow Flow_Control0_1 
	 auto flowFlow_Control0_1PeriodDistribution = readDistributionParameter("flowFlow_Control0_1.periodDistribution"); 
	 auto flowFlow_Control0_1PacketSizeDistribution = readDistributionParameter("flowFlow_Control0_1.packetSizeDistribution"); 
	 auto flowFlow_Control0_1 = std::make_shared<Flow>("Flow_Control0_1", 0 /*startTime*/, 0 /*typeOfService*/, flowFlow_Control0_1PeriodDistribution, flowFlow_Control0_1PacketSizeDistribution); 
	 // routes for flow Flow_Control0_1 
	 auto flowFlow_Control0_1_route0 = std::make_shared<Route>( std::deque<Route::Node>{ 
			 {1, "lar_felix_0.Routing"}, 
			 {2, "lar_switch_02.Routing"}, 
			 {1, "lar_swrod_0.Routing"} 
	 });	 
	 // register flow Flow_Control0_1 with its routes
	 FlowDefinitions::registerFlowSourceNode(flowFlow_Control0_1, "lar_felix_0.GeneratorApplication");  
	 FlowDefinitions::registerFlowRoute(flowFlow_Control0_1, flowFlow_Control0_1_route0);  
	 

	 ///// definition of flow Flow1_1 
	 auto flowFlow1_1PeriodDistribution = readDistributionParameter("flowFlow1_1.periodDistribution"); 
	 auto flowFlow1_1PacketSizeDistribution = readDistributionParameter("flowFlow1_1.packetSizeDistribution"); 
	 auto flowFlow1_1 = std::make_shared<Flow>("Flow1_1", 0 /*startTime*/, 0 /*typeOfService*/, flowFlow1_1PeriodDistribution, flowFlow1_1PacketSizeDistribution); 
	 // routes for flow Flow1_1 
	 auto flowFlow1_1_route0 = std::make_shared<Route>( std::deque<Route::Node>{ 
			 {0, "lar_felix_1.Routing"}, 
			 {3, "lar_switch_01.Routing"}, 
			 {0, "lar_swrod_1.Routing"} 
	 });	 
	 auto flowFlow1_1_route1 = std::make_shared<Route>( std::deque<Route::Node>{ 
			 {1, "lar_felix_1.Routing"}, 
			 {3, "lar_switch_02.Routing"}, 
			 {1, "lar_swrod_1.Routing"} 
	 });	 
	 // register flow Flow1_1 with its routes
	 FlowDefinitions::registerFlowSourceNode(flowFlow1_1, "lar_felix_1.GeneratorApplication");  
	 FlowDefinitions::registerFlowRoute(flowFlow1_1, flowFlow1_1_route0);  
	 FlowDefinitions::registerFlowRoute(flowFlow1_1, flowFlow1_1_route1);  
	 

	 ///// definition of flow Flow_Monitoring1_1 
	 auto flowFlow_Monitoring1_1PeriodDistribution = readDistributionParameter("flowFlow_Monitoring1_1.periodDistribution"); 
	 auto flowFlow_Monitoring1_1PacketSizeDistribution = readDistributionParameter("flowFlow_Monitoring1_1.packetSizeDistribution"); 
	 auto flowFlow_Monitoring1_1 = std::make_shared<Flow>("Flow_Monitoring1_1", 0 /*startTime*/, 0 /*typeOfService*/, flowFlow_Monitoring1_1PeriodDistribution, flowFlow_Monitoring1_1PacketSizeDistribution); 
	 // routes for flow Flow_Monitoring1_1 
	 auto flowFlow_Monitoring1_1_route0 = std::make_shared<Route>( std::deque<Route::Node>{ 
			 {0, "lar_felix_1.Routing"}, 
			 {3, "lar_switch_01.Routing"}, 
			 {0, "lar_swrod_1.Routing"} 
	 });	 
	 // register flow Flow_Monitoring1_1 with its routes
	 FlowDefinitions::registerFlowSourceNode(flowFlow_Monitoring1_1, "lar_felix_1.GeneratorApplication");  
	 FlowDefinitions::registerFlowRoute(flowFlow_Monitoring1_1, flowFlow_Monitoring1_1_route0);  
	 

	 ///// definition of flow Flow_Control1_1 
	 auto flowFlow_Control1_1PeriodDistribution = readDistributionParameter("flowFlow_Control1_1.periodDistribution"); 
	 auto flowFlow_Control1_1PacketSizeDistribution = readDistributionParameter("flowFlow_Control1_1.packetSizeDistribution"); 
	 auto flowFlow_Control1_1 = std::make_shared<Flow>("Flow_Control1_1", 0 /*startTime*/, 0 /*typeOfService*/, flowFlow_Control1_1PeriodDistribution, flowFlow_Control1_1PacketSizeDistribution); 
	 // routes for flow Flow_Control1_1 
	 auto flowFlow_Control1_1_route0 = std::make_shared<Route>( std::deque<Route::Node>{ 
			 {1, "lar_felix_1.Routing"}, 
			 {3, "lar_switch_02.Routing"}, 
			 {1, "lar_swrod_1.Routing"} 
	 });	 
	 // register flow Flow_Control1_1 with its routes
	 FlowDefinitions::registerFlowSourceNode(flowFlow_Control1_1, "lar_felix_1.GeneratorApplication");  
	 FlowDefinitions::registerFlowRoute(flowFlow_Control1_1, flowFlow_Control1_1_route0);  
	 
}
