import { useRef, useState, useEffect } from 'react';
import PixiGame from './PixiGame.tsx';
import { useElementSize } from 'usehooks-ts';
import { Stage } from '@pixi/react';
import { ConvexProvider, useConvex, useQuery } from 'convex/react';
import PlayerDetails from './PlayerDetails.tsx';
import { api } from '../../convex/_generated/api';
import { useWorldHeartbeat } from '../hooks/useWorldHeartbeat.ts';
import { useHistoricalTime } from '../hooks/useHistoricalTime.ts';
import { DebugTimeManager } from './DebugTimeManager.tsx';
import { GameId } from '../../convex/aiTown/ids.ts';
import { useServerGame } from '../hooks/serverGame.ts';

export const SHOW_DEBUG_UI = !!import.meta.env.VITE_SHOW_DEBUG_UI;

export default function Game() {
  const convex = useConvex();
  const [selectedElement, setSelectedElement] = useState<{
    kind: 'player';
    id: GameId<'players'>;
  }>();
  const [gameWrapperRef, { width, height }] = useElementSize();
  const worldStatus = useQuery(api.world.defaultWorldStatus);
  const worldId = worldStatus?.worldId;
  const engineId = worldStatus?.engineId;
  const game = useServerGame(worldId);
  
  // Определяем пропорции экрана
  const [isPortrait, setIsPortrait] = useState(false);
  
  useEffect(() => {
    const checkOrientation = () => {
      const ratio = window.innerWidth / window.innerHeight;
      // 4:5 = 0.8, если меньше - считаем портретной ориентацией
      setIsPortrait(ratio < 0.8);
    };
    
    checkOrientation();
    window.addEventListener('resize', checkOrientation);
    return () => window.removeEventListener('resize', checkOrientation);
  }, []);

  // Send a periodic heartbeat to our world to keep it alive.
  useWorldHeartbeat();
  const worldState = useQuery(api.world.worldState, worldId ? { worldId } : 'skip');
  const { historicalTime, timeManager } = useHistoricalTime(worldState?.engine);
  const scrollViewRef = useRef<HTMLDivElement>(null);

  if (!worldId || !engineId || !game) {
    return null;
  }

  return (
    <>
      {SHOW_DEBUG_UI && <DebugTimeManager timeManager={timeManager} width={200} height={100} />}
      
      {/* Основной контейнер игры */}
      <div className="mx-auto w-full max-w relative min-h-[480px] game-frame">
        {/* Игровая область */}
        <div className="w-full h-screen" ref={gameWrapperRef}>
          <div className="absolute inset-0">
            <div className="container">
              <Stage width={width} height={height} options={{ backgroundColor: 0x7ab5ff }}>
                <ConvexProvider client={convex}>
                  <PixiGame
                    game={game}
                    worldId={worldId}
                    engineId={engineId}
                    width={width}
                    height={height}
                    historicalTime={historicalTime}
                    setSelectedElement={setSelectedElement}
                  />
                </ConvexProvider>
              </Stage>
            </div>
          </div>
        </div>

        {/* Десктопная версия панели (справа) */}
        <div className={`chat_panel absolute right-0 top-0 h-full w-96 xl:w-[28rem] border-l-8 border-brown-900 bg-brown-800 text-brown-100 transition-all duration-300 ${isPortrait ? 'hidden' : 'block'}`}>
          <div 
            className="h-full flex flex-col overflow-y-auto px-4 py-6 sm:px-6 xl:pr-6"
            ref={scrollViewRef}
          >
            <PlayerDetails
              worldId={worldId}
              engineId={engineId}
              game={game}
              playerId={selectedElement?.id}
              setSelectedElement={setSelectedElement}
              scrollViewRef={scrollViewRef}
            />
          </div>
        </div>
      </div>

      {/* Мобильная версия панели (снизу при портретной ориентации) */}
      <div className={`chat_panel fixed bottom-0 left-0 right-0 border-t-8 border-brown-900 bg-brown-800 text-brown-100 z-10 transition-all duration-300 ${isPortrait ? 'block h-60' : 'hidden'}`}>
        <div 
          className="h-full flex flex-col overflow-y-auto px-4 py-6 sm:px-6"
          ref={scrollViewRef}
        >
          <PlayerDetails
            worldId={worldId}
            engineId={engineId}
            game={game}
            playerId={selectedElement?.id}
            setSelectedElement={setSelectedElement}
            scrollViewRef={scrollViewRef}
          />
        </div>
      </div>
    </>
  );
}