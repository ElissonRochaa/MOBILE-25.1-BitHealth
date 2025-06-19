import 'package:flutter/material.dart';

class ActionButtonGrid extends StatelessWidget {
  const ActionButtonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _ButtonData("Plantões", Icons.access_time, () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/plantoes',
          (Route<dynamic> route) => false,
        );
      }),
      _ButtonData("Vacinação", Icons.vaccines, () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/vacinacao',
          (Route<dynamic> route) => false,
        );
      }),
      _ButtonData("Notícias", Icons.article, () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/noticias',
          (Route<dynamic> route) => false,
        );
      }),
      _ButtonData("Ajuda", Icons.help_outline, () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ajuda - Funcionalidades do App'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHelpItem(Icons.access_time, 'Plantões', 'Visualize seus plantões médicos e horários de trabalho.'),
                    const SizedBox(height: 8),
                    _buildHelpItem(Icons.vaccines, 'Vacinação', 'Acompanhe seu calendário de vacinação e histórico de vacinas.'),
                    const SizedBox(height: 8),
                    _buildHelpItem(Icons.article, 'Notícias', 'Fique por dentro das últimas notícias da área da saúde.'),
                    const SizedBox(height: 8),
                    _buildHelpItem(Icons.map, 'Mapa', 'Encontre unidades de saúde próximas no mapa.'),
                    const SizedBox(height: 8),
                    _buildHelpItem(Icons.medical_services, 'Médicos', 'Consulte a lista de médicos disponíveis.'),
                    const SizedBox(height: 8),
                    _buildHelpItem(Icons.medication, 'Medicamentos', 'Veja seus medicamentos e prescrições.'),
                    const SizedBox(height: 8),
                    _buildHelpItem(Icons.build, 'Serviços', 'Conheça os serviços de saúde disponíveis.'),
                    const SizedBox(height: 8),
                    _buildHelpItem(Icons.home, 'Home', 'Volte para a tela inicial do app.'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        );
      }),
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3.5,
        children: buttons.map((btn) => _GridButton(data: btn)).toList(),
      ),
    );
  }
}

class _ButtonData {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  _ButtonData(this.label, this.icon, this.onPressed);
}

class _GridButton extends StatelessWidget {
  final _ButtonData data;

  const _GridButton({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: data.onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isDarkMode 
                ? Theme.of(context).colorScheme.surface.withOpacity(0.5)
                : Colors.white.withOpacity(0.8),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  data.icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data.label,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GridButtonModern extends StatefulWidget {
  final _ButtonData data;

  const _GridButtonModern({required this.data});

  @override
  State<_GridButtonModern> createState() => _GridButtonModernState();
}

class _GridButtonModernState extends State<_GridButtonModern>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: widget.data.onPressed,
              onTapDown: (_) {
                setState(() => _isPressed = true);
                _animationController.forward();
              },
              onTapUp: (_) {
                setState(() => _isPressed = false);
                _animationController.reverse();
              },
              onTapCancel: () {
                setState(() => _isPressed = false);
                _animationController.reverse();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _isPressed
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : isDarkMode
                          ? Theme.of(context).colorScheme.surface
                          : Colors.white,
                  border: Border.all(
                    color: _isPressed
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    width: _isPressed ? 2 : 1,
                  ),
                  boxShadow: _isPressed
                      ? []
                      : [
                          BoxShadow(
                            color: Theme.of(context).shadowColor.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          widget.data.icon,
                          color: _isPressed
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primary.withOpacity(0.8),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: _isPressed
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface,
                            fontSize: 14,
                            fontWeight: _isPressed ? FontWeight.w600 : FontWeight.w500,
                          ),
                          child: Text(
                            widget.data.label,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


Widget _buildHelpItem(IconData icon, String title, String description) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 24, color: Colors.blueAccent),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(description, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    ],
  );
}