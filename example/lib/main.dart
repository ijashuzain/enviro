import 'package:flutter/material.dart';
import 'gen/enviro.gen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize enviro with default environment
  await Enviro.initialize();
  
  runApp(const EnviroExampleApp());
}

class EnviroExampleApp extends StatelessWidget {
  const EnviroExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enviro Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const EnviroExampleHomePage(),
    );
  }
}

class EnviroExampleHomePage extends StatefulWidget {
  const EnviroExampleHomePage({super.key});

  @override
  State<EnviroExampleHomePage> createState() => _EnviroExampleHomePageState();
}

class _EnviroExampleHomePageState extends State<EnviroExampleHomePage> {
  EnviroEnvironment _currentEnvironment = EnviroEnvironment.DEFAULT;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enviro Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Environment Selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Environment Selection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<EnviroEnvironment>(
                            value: _currentEnvironment,
                            isExpanded: true,
                            items: EnviroEnvironment.values.map((env) {
                              return DropdownMenuItem(
                                value: env,
                                child: Text(env.name),
                              );
                            }).toList(),
                            onChanged: (EnviroEnvironment? newValue) async {
                              if (newValue != null) {
                                await _switchEnvironment(newValue);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () => _switchEnvironment(_currentEnvironment),
                          child: const Text('Refresh'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Environment Variables Display
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Environment Variables',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_errorMessage.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.red.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error, color: Colors.red.shade600),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage,
                                  style: TextStyle(color: Colors.red.shade800),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Expanded(
                        child: _buildEnvironmentVariables(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentVariables() {
    try {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVariableRow('API URL', Enviro.apiUrl, Icons.link),
            _buildVariableRow('Database URL', Enviro.databaseUrl, Icons.storage),
            _buildVariableRow('Debug Mode', Enviro.debug.toString(), Icons.bug_report),
            _buildVariableRow('Port', Enviro.port.toString(), Icons.settings_ethernet),
            _buildVariableRow('Environment', Enviro.environment, Icons.sunny),
            _buildVariableRow('Log Level', Enviro.logLevel, Icons.logo_dev),
            _buildVariableRow('Timeout', Enviro.timeout.toString(), Icons.timer),
            _buildVariableRow('Max Retries', Enviro.maxRetries.toString(), Icons.refresh),
            _buildVariableRow('Analytics Enabled', Enviro.enableAnalytics.toString(), Icons.analytics),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(color: Colors.green.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'All environment variables loaded successfully!',
                      style: TextStyle(color: Colors.green.shade800),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Error loading environment variables:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              e.toString(),
              style: TextStyle(color: Colors.red.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _switchEnvironment(_currentEnvironment);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildVariableRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade600),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                value,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _switchEnvironment(EnviroEnvironment environment) async {
    try {
      setState(() {
        _errorMessage = '';
      });
      
      await Enviro.setEnvironment(environment);
      
      setState(() {
        _currentEnvironment = environment;
      });
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Switched to ${environment.name} environment'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error switching environment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
